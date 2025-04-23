extends Node3D

@export var animation_name: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transform.origin = Vector3.ZERO

	
func play_animation():
	$AnimationPlayer.play(animation_name)
	$AnimationPlayer.get_animation(animation_name).loop = true
