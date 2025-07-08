extends Node3D

@export var starting_capital: int = 100

var game_started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.set_money(starting_capital)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init(mocap: bool, no_legs: bool, starting_wave:int):
	if mocap:
		$Player.set_walking_type("mocap")
		$Player.start_udp_script()
	elif no_legs:
		$Player.set_walking_type("no legs")
	
	#TODO: add way to start at later wave
	
func start_game():
	print("starting game")
	game_started = true
	$EnemySpawner.start_spawning()


func _on_viewport_2_din_3d_start_game() -> void:
	print("recieved signal")
	start_game()


func _on_enemy_spawner_enemy_died(worth: int) -> void:
	$Player.earn(worth)
