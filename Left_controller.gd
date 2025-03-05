extends XRController3D

@export var object_scene: PackedScene  # Assign your object scene in the Inspector
@onready var raycast = $RayCast3D  # Make sure the path is correct

var ground
var preview_instance: Node3D = null
var build_mode: bool = true

func _ready():
	ground = get_tree().current_scene.get_node_or_null("Ground")
	create_preview()

func _process(delta):
	if build_mode:
		handle_build_mode()


func switch_mode():
	if build_mode:  #switch to repair mode
		build_mode = false
		hide_preview()
		$LeftHand.hide()
		$Wrench.activate()
	else:
		build_mode = true
		$LeftHand.show()
		$Wrench.deactivate()


	
	
func handle_build_mode():
	if raycast.is_colliding():
		var collider = raycast.get_collider()  # Gets the object the ray is colliding with
		if collider == ground:  #make sure it gets placed on the grSound
			var collision_point = raycast.get_collision_point()  # Get the collision point
			update_preview_position(collision_point)
		else:
			hide_preview()
	else:
		hide_preview()


func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_KP_3:
			switch_mode()
			return
	if raycast.is_colliding() and raycast.get_collider() == ground: #first check if the tower can in fact be placed
		if event is InputEventKey and event.is_pressed():
			if event.keycode == KEY_KP_2:
				place_object()

func place_object():
	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		var new_object = object_scene.instantiate()
		var towers_node = get_tree().current_scene.get_node("Tower_manager")  # Ensure "Towers" node path is correct

		if towers_node:
			new_object.global_transform.origin = collision_point
			towers_node.add_child(new_object)
		else:
			print("Towers node not found!")
		new_object.place()

func create_preview():
	if object_scene:
		preview_instance = object_scene.instantiate()
		var towers_node = get_tree().current_scene.get_node("Tower_manager")  # Ensure "Towers" node path is correct
		if towers_node:
			towers_node.add_child(preview_instance)
		else:
			print("Towers node not found!")
		preview_instance.visible = false



func update_preview_position(collision_point):
	if preview_instance:
		if preview_instance.global_transform.origin != collision_point:
			preview_instance.global_transform.origin = collision_point
		preview_instance.visible = true

func hide_preview():
	if preview_instance:
		preview_instance.visible = false

