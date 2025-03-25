extends Node3D

@export var starting_capital: int = 100

var game_started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.set_money(starting_capital)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_game():
	print("starting game")
	game_started = true
	$EnemySpawner.start_spawning()


func _on_viewport_2_din_3d_start_game() -> void:
	print("recieved signal")
	start_game()


func _on_enemy_spawner_enemy_died(worth: int) -> void:
	$Player.earn(worth)
