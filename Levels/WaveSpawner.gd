extends Node3D

@export var spawn_interval: float = 2.0
@export var path: Path3D
@export var enemy_scenes: Dictionary # {"basic": PackedScene}

var enemies_spawned: int = 0
var enemies_killed: int = 0
var enemies_in_wave
var timer = null

signal wave_done
signal enemy_reach_end


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_wave(wave):
	enemies_spawned = 0
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(func(): spawn_enemy(wave))
	add_child(timer)


func spawn_enemy(wave):
	if not path:
		print("path not found")
		return

	var enemy_type = wave["type"]

	if not enemy_scenes.has(enemy_type):
		print("Enemy type not found:", enemy_type)
		return
	
	enemies_in_wave = wave["amount"]
	var enemy = enemy_scenes[enemy_type].instantiate() as PathFollow3D
	path.add_child(enemy)
	enemy.progress = 0 
	enemy.reached_end.connect(_on_enemy_reached_end)
	enemy.enemy_died.connect(_on_enemy_died)
	enemies_spawned += 1
	if enemies_spawned >= enemies_in_wave:
		if timer:
			timer.stop()
			timer.queue_free()
			timer = null
		#make start wave button visible again


func _on_enemy_reached_end(enemy):
	enemy_reach_end.emit(enemy)

func _on_enemy_died(worth: int):
	enemies_killed += 1
	get_parent().enemy_killed(worth)
	if enemies_killed >= enemies_in_wave:
		enemies_killed = 0
		$StartGameViewport.wave_finished()
		wave_done.emit()
		
	$SubViewport/Kill_count.enemy_died()
