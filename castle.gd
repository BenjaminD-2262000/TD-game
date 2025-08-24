extends Node3D

var castle_damage: int = 50

var castle_destroyed = false

signal game_over
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func take_damage(damage):
	if $SubViewport/Healthbar.value <= damage:
		damage = $SubViewport/Healthbar.value
		castle_destroyed = true
		game_over.emit()
	$SubViewport/Healthbar.value -= damage
	$SubViewport/Healthbar.queue_redraw()

func handle_enemy_at_door(enemy):

	if not is_instance_valid(enemy):  
		return  # Enemy is already deleted, stop execution
	if not castle_destroyed:
		take_damage(enemy.damage)
		enemy.take_damage(castle_damage)

func _on_wave_spawner_enemy_reach_end(enemy):
	if enemy.has_meta("damage_timer"):  #only one timer
		return

	var timer = Timer.new()
	timer.wait_time = 1.0 #damage every second
	timer.autostart = true
	add_child(timer)

	enemy.set_meta("damage_timer", timer)

	handle_enemy_at_door(enemy) #instantly handle first tick
	timer.timeout.connect(func():
		if not is_instance_valid(enemy):
			timer.queue_free()
			return  
		handle_enemy_at_door(enemy)
	)
