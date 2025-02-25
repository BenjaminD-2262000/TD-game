extends Node3D


@export var spawn_interval: float = 2.0  # Seconds between spawns
@export var path: Node3D


var enemy_waves = []  # Stores the parsed JSON waves
var wave_index = 0  # Tracks which enemy to spawn next


func _ready():
	load_waves()
	start_spawning()
	set_process(true)

func _process(delta):
	pass
	
	
func load_waves():
	var file = FileAccess.open("res://Levels/debug_waves.json", FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		enemy_waves = JSON.parse_string(json_string)
		file.close()
	else:
		print("Failed to load enemy wave file!")

func start_spawning():
	$WaveSpawner.spawn_wave(enemy_waves[wave_index])
	wave_index += 1


func _on_wave_spawner_wave_done():
	if wave_index >= enemy_waves.size():
		return
	$WaveSpawner.spawn_wave(enemy_waves[wave_index])
	wave_index += 1
	
