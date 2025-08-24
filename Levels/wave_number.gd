extends Label

var total_waves: int
var current_wave: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Wave:" + str(current_wave) + "/" + str(total_waves)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_total_waves(amount):
	total_waves = amount
	
func next_wave():
	current_wave += 1
	_ready()
