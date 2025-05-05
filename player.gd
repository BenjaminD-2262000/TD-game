extends XROrigin3D

@onready var moneyLabel = $Left_Hand/MoneyViewport/Money
var money: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	moneyLabel.text = str(money)

func can_afford(cost: int):
	return cost <= money

func set_money(amount: int):
	money = amount

func pay(amount: int):
	money -= amount

func earn(amount: int):
	money += amount
