extends PathFollow3D


@export var health: int = 100
@export var speed: float = 10.0
@export var damage: float = 1.0
signal reached_end

# Called when the node enters the scene tree for the first time.
func _ready():
	$CharacterBody3D/SubViewport/HPBar.max_value = health
	$CharacterBody3D/SubViewport/HPBar.value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress += speed * delta
	
	if progress_ratio >= 1.0:  #canot be to precise
		reached_end.emit(self)



func take_damage(amount: int):
	health -= amount
	$CharacterBody3D/SubViewport/HPBar.value = health
	$CharacterBody3D/SubViewport/HPBar.queue_redraw()
	if health <=0:
		die()
		

func die():
	queue_free()
