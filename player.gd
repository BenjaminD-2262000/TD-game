extends XROrigin3D

@onready var moneyLabel = $Left_Hand/MoneyViewport/Money
@onready var movementcontroller = $Left_Hand/MovementDirect
var money: int = 0
var walkingspeed: float
var walkingtype = "no_cap"

@onready var prev_y_pos = $XRCamera3D.global_transform.origin.y
# Called when the node enters the scene tree for the first time.

var step_count = 0
var step_start_time
var step_length = 0.9  #how many meters per step

func _ready() -> void:
	step_start_time = Time.get_ticks_msec() / 1000.0

func init_player():
	$Left_Hand.ground = get_tree().current_scene.get_node_or_null("Ground")
	$Left_Hand.create_preview()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	moneyLabel.text = str(money)
	if walkingtype == "no_cap":
		update_walk_no_cap()
	elif walkingtype == "no_legs":
		update_walk_no_legs()
	
	#update walking speed in the controller
	$Left_Hand/MovementDirect.walkingspeed = walkingspeed

func create_tower_preview():
	$Left_Hand.create_preview()

#handles walking by moving controllers
func update_walk_no_legs():
	pass
	#TODO: add walking by moving arms in walk like motion


#handles walking if there is no motion capture system by loking at head going up or down
func update_walk_no_cap():
	var y_position = $XRCamera3D.global_transform.origin.y
	if abs(y_position - prev_y_pos) > 10:
		step_count += 1
	
	# Calculate speed every few seconds or as needed
	var current_time = Time.get_ticks_msec() / 1000.0
	var elapsed_time = current_time - step_start_time
	
	if elapsed_time >= 0.10: # Calculate every second
		var speed = (step_count * step_length) / elapsed_time # m/0.1s
		speed = speed * 10
		walkingspeed = speed
		# Reset tracking for next interval
		step_count = 0
		step_start_time = current_time


func start_udp_script():
	$UDP_listener.run_script()

func set_walking_type(walkingtype_choice: String):
	$Left_Hand/MovementDirect.input_action = walkingtype_choice
	walkingtype = walkingtype_choice
	

func can_afford(cost: int):
	return cost <= money

func set_money(amount: int):
	money = amount

func pay(amount: int):
	money -= amount

func earn(amount: int):
	money += amount
