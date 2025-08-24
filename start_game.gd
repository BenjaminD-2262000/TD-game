extends CanvasLayer

var motion_capture = true
var no_legs = false
var starting_wave = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_max_starter_Wave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_max_starter_Wave():
	var file = FileAccess.open("res://Levels/debug_waves.json", FileAccess.READ)
	var enemy_waves
	if file:
		var json_string = file.get_as_text()
		enemy_waves = JSON.parse_string(json_string)
		file.close()

	else:
		print("Failed to load enemy wave file!")
	$"Control/ColorRect/Button_H/MarginContainer/HBoxContainer/starting wave".max_value = enemy_waves.size()

func _on_start_game_pressed() -> void:
	motion_capture = $"Control/ColorRect/Button_H/Buttons/Motion capture".button_pressed
	no_legs = $"Control/ColorRect/Button_H/Buttons/No legs mode".button_pressed
	#displayed value starts at one for player convenience but backend uses 0 indexing
	starting_wave = $"Control/ColorRect/Button_H/MarginContainer/HBoxContainer/starting wave".value - 1
	var level = load("res://Levels/Debug.tscn").instantiate()
	level.init(motion_capture, no_legs, starting_wave)
	
	get_tree().get_root().add_child(level)
	get_tree().get_current_scene().queue_free()
	get_tree().set_current_scene(level)
	
