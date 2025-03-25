extends Node3D

signal wheel_moving
signal wheel_stopped
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_interactable_hinge_wheel_moving() -> void:
	wheel_moving.emit()

func _on_interactable_hinge_wheel_stopped() -> void:
	wheel_moving.emit()

func disable():
	$HingeOrigin/HandPoseArea/CollisionShape3D.disabled = true
	$HingeOrigin/InteractableHinge/WheelBody/CollisionShape3D.disabled = true
	$HingeOrigin/InteractableHinge/Handle1/InteractableHandle/CollisionShape3D.disabled = true
	
func activate():
	$HingeOrigin/HandPoseArea/CollisionShape3D.disabled = false
	$HingeOrigin/InteractableHinge/WheelBody/CollisionShape3D.disabled = false
	$HingeOrigin/InteractableHinge/Handle1/InteractableHandle/CollisionShape3D.disabled = false
