extends Label

var kill_count: int = 0
var wave_size: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	text =  str(kill_count, "/", wave_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func enemy_died():
	kill_count += 1
	_ready()

func set_wave_size(found_wave_size):
	wave_size = found_wave_size
	_ready()
