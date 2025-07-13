extends CanvasLayer

var motion_capture = true
var no_legs = false
var starting_wave = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_game_pressed() -> void:
	motion_capture = $"Control/ColorRect/Button_H/Buttons/Motion capture".button_pressed
	no_legs = $"Control/ColorRect/Button_H/Buttons/No legs mode".button_pressed
	starting_wave = $"Control/ColorRect/Button_H/MarginContainer/HBoxContainer/starting wave".value
	var level = load("res://Levels/Debug.tscn").instantiate()
	level.init(motion_capture, no_legs, starting_wave)
	
	print("adding child")
	get_tree().get_root().add_child(level)
	print("added child")
	get_tree().get_current_scene().queue_free()
	print("removed menu")
	get_tree().set_current_scene(level)
	print("set new scene")
	
