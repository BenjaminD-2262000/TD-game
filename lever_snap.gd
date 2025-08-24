extends Node3D

signal full_crank

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deactivate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func deactivate():
	$Frame/CollisionShape3D.disabled = true
	$LeverOrigin/InteractableLever/HingeBody/BarCollision.disabled = true
	$LeverOrigin/InteractableLever/HingeBody/HandleCollision.disabled = true
	$LeverOrigin/InteractableLever/HandleOrigin/InteractableHandle/CollisionShape3D.disabled = true
	
func activate():
	$Frame/CollisionShape3D.disabled = false
	$LeverOrigin/InteractableLever/HingeBody/BarCollision.disabled = false
	$LeverOrigin/InteractableLever/HingeBody/HandleCollision.disabled = false
	$LeverOrigin/InteractableLever/HandleOrigin/InteractableHandle/CollisionShape3D.disabled = false

func _on_interactable_lever_full_crank() -> void:
	full_crank.emit() # Replace with function body.
