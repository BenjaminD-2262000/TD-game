extends Node3D


@export var spawn_interval: float = 2.0  # Seconds between spawns
@export var path: Node3D


var enemy_waves = []  # Stores the parsed JSON waves
var wave_index = 0  # Tracks which enemy to spawn next

var wave_size: int = 0

signal enemy_died(worth: int)

func _ready():
	load_waves()
	set_process(true)

func _process(delta):
	pass
	
	
func load_waves():
	var file = FileAccess.open("res://Levels/debug_waves.json", FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		enemy_waves = JSON.parse_string(json_string)
		file.close()
		
		for i in range(enemy_waves.size()):
			wave_size += enemy_waves[i]["amount"]

	else:
		print("Failed to load enemy wave file!")
	$WaveSpawner/SubViewport/Kill_count.set_wave_size(wave_size)

func start_spawning():
	
	$WaveSpawner.spawn_wave(enemy_waves[wave_index])
	wave_index += 1
		#TODO: set game completed screen


func _on_wave_spawner_wave_done() -> void:
	if wave_index >= enemy_waves.size():
		$WaveSpawner/GameFinishedViewport.show()
		$WaveSpawner/StartGameViewport.hide()
		return

func enemy_killed(worth: int):
	enemy_died.emit(worth)
