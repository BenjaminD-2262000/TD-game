extends XRController3D

@export var object_scene: PackedScene  # Assign your object scene in the Inspector
@export var tower_list: Array
var current_tower: int = 0
@onready var raycast = $RayCast3D  # Make sure the path is correct

var ground
var preview_instance: Node3D = null
var build_mode: bool = true
var current_displayed_tower_cost: int

func _ready():
	pass

func _process(delta):

	if build_mode:
		handle_build_mode() 

func switch_mode():
	if build_mode:  #switch to repair mode
		build_mode = false
		hide_preview()
		$LeftHand.hide()
		$MoneySprite.hide()
		$Wrench.activate()
	else:
		build_mode = true
		$LeftHand.show()
		$MoneySprite.show()
		$Wrench.deactivate()


func switch_tower():
	delete_preview()
	if current_tower < tower_list.size() - 1:
		current_tower += 1
	else:
		current_tower = 0
	object_scene = tower_list[current_tower]
	create_preview()

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

func _on_button_pressed(name: String) -> void:
	print(name)
	if build_mode:
		if name == "ax_button":
			switch_tower()
			return
		
		elif raycast.is_colliding() and raycast.get_collider() == ground: #first check if the tower can in fact be placed
			if name == "trigger_click":
				place_object()

	elif name == "by_button":
		switch_mode()
		return
	
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_KP_3:
			switch_tower()
			return
		elif event.keycode == KEY_KP_4:
			switch_mode()
			return


	if raycast.is_colliding() and raycast.get_collider() == ground: #first check if the tower can in fact be placed
		if event is InputEventKey and event.is_pressed():
			if event.keycode == KEY_KP_2:
				place_object()

func place_object():
	if not get_parent().can_afford(current_displayed_tower_cost):
		return
	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		var new_object = object_scene.instantiate()
		var towers_node = get_tree().current_scene.get_node("Tower_manager")  # Ensure "Towers" node path is correct

		if towers_node:
			new_object.global_transform.origin = collision_point
			new_object.pay_for_upgrade.connect(_on_pay_for_upgrade)
			towers_node.add_child(new_object)
		else:
			print("Towers node not found!")
		new_object.place()
		get_parent().pay(current_displayed_tower_cost)

func _on_pay_for_upgrade(upgrade_cost: int):
	get_parent().pay(upgrade_cost)

func create_preview():
	if object_scene:
		preview_instance = object_scene.instantiate()
		current_displayed_tower_cost = preview_instance.cost
		$CostViewport/TowerCost.text = str(current_displayed_tower_cost)
		var towers_node = get_tree().current_scene.get_node("Tower_manager")  # Ensure "Towers" node path is correct
		if towers_node:
			towers_node.add_child(preview_instance)
		else:
			print("Towers node not found!")
		preview_instance.visible = false

func delete_preview():
	if preview_instance:
		preview_instance.queue_free()

func update_preview_position(collision_point):
	if preview_instance:
		if preview_instance.global_transform.origin != collision_point:
			preview_instance.global_transform.origin = collision_point
		preview_instance.visible = true

func hide_preview():
	if preview_instance:
		preview_instance.visible = false
