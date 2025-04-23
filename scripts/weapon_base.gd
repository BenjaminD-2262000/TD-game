extends Node3D

@export var damage: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#virtual function for activating the weapon upon weapon switch
func activate():
	pass

#virtual function for deactivating the weapon upon weapon switch
func deactivate():
	pass
