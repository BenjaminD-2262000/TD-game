extends XROrigin3D

@onready var moneyLabel = $Left_Hand/MoneyViewport/Money
@onready var movementcontroller = $Left_Hand/MovementDirect
var money: int = 0
var walkingspeed: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	moneyLabel.text = str(money)
	var y_position = $XRCamera3D.global_transform.origin.y
	$Left_Hand/MovementDirect.walkingspeed = walkingspeed

func can_afford(cost: int):
	return cost <= money

func set_money(amount: int):
	money = amount

func pay(amount: int):
	money -= amount

func earn(amount: int):
	money += amount
