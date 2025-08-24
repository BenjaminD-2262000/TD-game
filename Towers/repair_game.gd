extends Node3D

@export var spawn_range: float = 0.7
@export var nr_of_screws: int = 3 #the amount of screws that need to be screwed in to fix the tower

var screws_bolted: int = 0
signal repair_game_done

@onready var screw_mesh = $Screw

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func spawn_screw():
	var random_position = Vector3(
		randf_range(spawn_range*-1, spawn_range),
		randf_range(spawn_range*-1, spawn_range),
		0
	)

	$Screw.position = random_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_repair():
	screws_bolted = 0
	$Screw.monitorable = true
	$Screw.monitoring = true
	screw_mesh.show()
	
	spawn_screw()



func disable_game():
	$Screw.monitorable = false
	$Screw.monitoring = false
	screw_mesh.hide()
	

func screwed_in():
	screws_bolted += 1
	if screws_bolted >= nr_of_screws:
		repair_game_done.emit()
		disable_game()
	else:
		spawn_screw()


func _on_screw_area_entered(area: Area3D) -> void:
	#only wrench is on same collision mask so only the wrench should be able 
	#to interact with it screw
	screwed_in()
	print(area)
