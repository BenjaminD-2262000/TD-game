extends Node3D

@onready var hitbox: Area3D = $hitbox

var is_active: bool = false  # Track if the hammer is enabled
var can_hit: bool = false  # Prevent multiple hits in one swing

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func activate():

	is_active = true
	can_hit = true  # Reset hit state
	show()
	if hitbox:
		hitbox.monitoring = true  # Enable hit detection
		hitbox.body_entered.connect(_on_hitbox_body_entered)
		

func deactivate():

	is_active = false
	hide()
	if hitbox:
		hitbox.monitoring = false  # Disable hit detection
		hitbox.body_entered.disconnect(_on_hitbox_body_entered)


func _on_hitbox_body_entered(body):
	if body.name == "Tower":
		body.get_parent().repair()
