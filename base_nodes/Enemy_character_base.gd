extends CharacterBody3D
class_name Enemy

signal Enemy_hit(damage)
signal Enemy_died
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_on_fire(time: float, damage: float):
	get_parent().set_on_fire(time, damage)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(damage):
	Enemy_hit.emit(damage)
