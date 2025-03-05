extends XRController3D

@export var weapon_list: Array[NodePath]
var current_weapon_index: int = 0
var previous_button_state: bool = false

var current_weapon: Node = null
# Called when the node enters the scene tree for the first time.
func _ready():
	if weapon_list.size() > 0:
		_switch_weapon(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _input(event):
	#TODO: REMOVE NUMPAD 2 AS SWITCH WEAPON, IS SIMPLY DEBUG
	if event.is_action_pressed("ax_button") or event.is_action_pressed("Switch Weapon"):

		_switch_weapon((current_weapon_index + 1) % weapon_list.size())

func _switch_weapon(new_index: int):
	# Deactivate the current weapon
	if current_weapon:
		if current_weapon.has_method("deactivate"):
			current_weapon.deactivate()
		current_weapon.hide()
		current_weapon = null  # Remove reference to avoid conflicts

	# Update index
	current_weapon_index = new_index

	# Activate the new weapon
	var new_weapon = get_node_or_null(weapon_list[current_weapon_index])
	if new_weapon:
		current_weapon = new_weapon
		if current_weapon.has_method("activate"):
			current_weapon.activate()
		current_weapon.show()

func get_active_weapon():
	return current_weapon
