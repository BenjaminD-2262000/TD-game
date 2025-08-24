extends Node3D

@export var spawn_interval: float = 2.0
@export var path: Path3D
@export var enemy_scenes: Dictionary # {"basic": PackedScene}

var enemies_spawned: int = 0
var enemies_killed_wave: int = 0
var enemies_killed_total: int = 0
var enemies_in_wave
var enemies_of_type
var enemie_type_in_wave: int = 0
var timer = null


signal wave_done
signal enemy_reach_end


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_wave(wave, wave_size):
	enemie_type_in_wave = 0
	enemies_in_wave = wave_size
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

	var enemy_type = wave[enemie_type_in_wave]["type"]

	if not enemy_scenes.has(enemy_type):
		print("Enemy type not found:", enemy_type)
		return
	
	enemies_of_type = wave[enemie_type_in_wave]["amount"]
	var enemy = enemy_scenes[enemy_type].instantiate() as PathFollow3D
	enemy.position = Vector3(0, -10, 0)
	path.add_child(enemy)
	enemy.progress = 0 
	enemy.reached_end.connect(_on_enemy_reached_end)
	enemy.enemy_died.connect(_on_enemy_died)
	enemies_spawned += 1
	
	if enemies_spawned >= enemies_of_type:
		enemie_type_in_wave += 1
		enemies_spawned = 0
		if enemie_type_in_wave >= wave.size():
			if timer:
				timer.stop()
				timer.queue_free()
				timer = null


func _on_enemy_reached_end(enemy):
	enemy_reach_end.emit(enemy)

func _on_enemy_died(worth: int):
	enemies_killed_wave += 1
	enemies_killed_total += 1
	get_parent().enemy_killed(worth)
	if enemies_killed_wave >= enemies_in_wave:
		enemies_killed_wave = 0
		wave_done.emit()
		
	$SubViewport/Kill_count.enemy_died()
