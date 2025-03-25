extends "res://scripts/weapon_base.gd"

@export var hitbox: Area3D
@export var time_on_fire: float

var is_active: bool = false  # Track if the hammer is enabled
var can_hit: bool = false  # Prevent multiple hits in one swing

# Called when the node enters the scene tree for the first time.
func _ready():
	deactivate() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func activate():

	is_active = true
	can_hit = false
	if hitbox:
		hitbox.monitoring = true  # Enable hit detection
		hitbox.body_entered.connect(_on_hitbox_body_entered)
	$Node3D/WheelSmooth.activate()

func deactivate():

	is_active = false
	if hitbox:
		hitbox.monitoring = false  # Disable hit detection
		hitbox.body_entered.disconnect(_on_hitbox_body_entered)
	$Node3D/WheelSmooth.disable()


func _on_hitbox_body_entered(body):
	if body is Enemy and can_hit:
		print("setting enemy on fire")
		body.set_on_fire(time_on_fire, damage)
	


func _on_wheel_smooth_wheel_moving() -> void:
	can_hit = true
	print("flame on !!!!!!!!!!!!!!!!")
	$Node3D/FireRange.show()
	return


func _on_wheel_smooth_wheel_stopped() -> void:
	can_hit = false
	$Node3D/FireRange.hide()
	return
