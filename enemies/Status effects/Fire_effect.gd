extends StatusEffect
class_name BurningEffect

var damage_per_tick: float = 0.0

func _init(_enemy, _duration, _damage_per_tick):
	super(_enemy, _duration)
	damage_per_tick = _damage_per_tick

func _ready():
	apply_effect()  # Apply the first tick immediately

	var timer = Timer.new()
	timer.wait_time = 1.0  # Apply damage every second
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_tick)

func _on_tick():
	if enemy and duration > 0:
		enemy.take_damage(damage_per_tick, "fire")
		duration -= 1
	else:
		end_effect()
