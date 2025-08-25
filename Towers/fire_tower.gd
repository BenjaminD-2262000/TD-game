extends "res://base_nodes/Tower_base.gd"

@export var fire_duration: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	repair_game.disable_game()
	
	hitbox = $Range
	hitbox.monitoring = true
	hitbox.body_entered.connect(_on_enemy_entered_range)
	hitbox.body_exited.connect(_on_enemy_exit_range)
	
	update_range()
	
	set_damage_timer()
	
	set_next_level_stats(1)

##shoots the fire
func effect():
	if not (placed and setup) or broken:
		return
	#turn the range red to signal fire
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1, 0, 0)  # RGB (Red)
	$Range/MeshInstance3D.set_surface_override_material(0, mat)
	
	# Create a timer to continuously apply fire damage for 0.5s
	var fire_timer = Timer.new()
	fire_timer.wait_time = 0.1  # Apply damage every 0.1s (adjustable)
	fire_timer.autostart = true
	fire_timer.one_shot = false  # Keep running for 0.5s
	add_child(fire_timer)

	fire_timer.timeout.connect(damage_enemys)

	# Stop the timer after 0.5 seconds
	await get_tree().create_timer(0.5).timeout  
	fire_timer.queue_free()  # Remove the timer
	
	await get_tree().create_timer(0.5).timeout 	#wait for a little and turn white again
	mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0, 0, 0)  # RGB (white)
	$Range/MeshInstance3D.set_surface_override_material(0, mat)

func damage_enemys():
	for enemy in enemies_in_range:
		enemy.set_on_fire(fire_duration, damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_entered_range(enemy):
	if not enemy is Enemy or not setup or broken:
		return
	
	enemy.Enemy_died.connect(_on_enemy_in_range_died)
	enemies_in_range.push_back(enemy)
	
func _on_lever_snap_full_crank() -> void:
	if not placed:
		return
	if setup_fase > 0:
		setup_fase -= 1
		$Pivot.position.y += 1
	else:
		set_transparancy(VISIBLE)
		setup = true
		remove_child($LeverSnap)

func _on_enemy_exit_range(enemy):
	remove_enemy(enemy)

func _on_enemy_in_range_died(enemy, worth):
	remove_enemy(enemy)

func remove_enemy(enemy):
	if current_enemies.has(enemy):
		current_enemies.erase(enemy)
		if enemies_in_range.size() > 0 and current_enemies.size() < max_enemy_hit:
			current_enemies.push_back(enemies_in_range.pop_front())
		
	else:
		enemies_in_range.erase(enemy)
