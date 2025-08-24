extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_game_won():
	$Control/ColorRect.color = Color.BLUE
	
	var label = $Control/ColorRect/MarginContainer/VBoxContainer/Label
	label.text = 'CONGRADULATIONS, YOU WON'

func set_game_over(wave: int, enemies: int):
	$Control/ColorRect.color = Color.RED
	
	var label = $Control/ColorRect/MarginContainer/VBoxContainer/Label
	label.text = 'GAME OVER \n Enemies killed: ' + str(enemies) + '\n Wave: ' + str(wave)
