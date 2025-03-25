extends Node3D


var rng = RandomNumberGenerator.new()
@export var break_change: int = 100
@export var break_interval: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var break_timer = Timer.new()
	break_timer.wait_time = break_interval
	break_timer.autostart = true
	break_timer.timeout.connect(func(): handle_breaking())
	add_child(break_timer)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#gives a chance for each tower to get broken down each second
func handle_breaking():
	var towers = get_children()
	#remove the timer and the preview tower
	towers.pop_front()
	towers.pop_front()
	
	if towers.size() <= 0:
		return

	var nr_of_towers = towers.size()
	var random_number = rng.randi_range(0, break_change)

	if random_number == 1:			#1 in 10 chance
		var random_tower = rng.randi_range(0, nr_of_towers - 1)
		towers[random_tower].breakdown()
