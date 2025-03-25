extends CanvasLayer
var viewport
var game_done
var game_over
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport = get_parent().get_parent()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func enable():
	pass
func _on_start_wave_pressed():
	viewport.on_start_game()
