extends Node3D


@export var spawn_interval: float = 2.0  # Seconds between spawns
@export var path: Node3D

@onready var end_game_window = $WaveSpawner/GameFinishedViewport

var enemy_waves = []  # Stores the parsed JSON waves
var wave_index = 0  # Tracks which enemy to spawn next
var total_waves
var wave_size: int = 0
var game_over = false

const GAME_END_PATH = 'res://Levels/game_end.tscn'

signal enemy_died(worth: int)

func _ready():
	load_waves()
	set_process(true)

func _process(delta):
	pass

func set_wave(wave_nr: int):
	wave_index = wave_nr

func load_waves():
	var file = FileAccess.open("res://Levels/debug_waves.json", FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		enemy_waves = JSON.parse_string(json_string)
		file.close()

	else:
		print("Failed to load enemy wave file!")
	total_waves = enemy_waves.size()
	$WaveSpawner/SubViewport/Wave_number.set_total_waves(total_waves)
	$WaveSpawner/SubViewport/Wave_number.current_wave = wave_index

func set_kill_counter():
	wave_size = 0
	for i in range(enemy_waves[wave_index].size()):
			wave_size += enemy_waves[wave_index][i]["amount"]
	$WaveSpawner/SubViewport/Kill_count.set_wave_size(wave_size)


func start_spawning():
	set_kill_counter()
	$WaveSpawner.spawn_wave(enemy_waves[wave_index], wave_size)
	$WaveSpawner/SubViewport/Wave_number.next_wave()
	wave_index += 1


func _on_wave_spawner_wave_done() -> void:
	if wave_index >= total_waves - 1:
		game_won()
		return
	elif game_over:
		return
	else:
		$WaveSpawner/StartGameViewport.wave_finished()

func game_won():
	var game_over_scene = load(GAME_END_PATH)
	
	end_game_window.set_scene(game_over_scene)
	end_game_window.set_game_won()
	end_game_window.show()
	$WaveSpawner/StartGameViewport.hide()

func _on_castle_game_over() -> void:
	game_over = true
	var game_over_scene = load(GAME_END_PATH)
	
	end_game_window.set_scene(game_over_scene)
	end_game_window.set_game_over(wave_index, $WaveSpawner.enemies_killed_total)
	end_game_window.show()

func enemy_killed(worth: int):
	enemy_died.emit(worth)
