extends StatusEffect
class_name BurningEffect

var damage_per_tick: float = 0.0

func _init(_enemy, _duration, _damage_per_tick):
	super(_enemy, _duration)
	damage_per_tick = _damage_per_tick
	effect_symbol = preload("res://enemies/Fire.png")

func _ready():
	var time_left_on_fire = Timer.new()
	time_left_on_fire.wait_time = duration
	time_left_on_fire.autostart = true
	time_left_on_fire.one_shot = false
	add_child(time_left_on_fire)
	time_left_on_fire.timeout.connect(end_effect)
	
	var timer = Timer.new()
	timer.wait_time = 1.0  # Apply damage every second
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_tick)
	_on_tick()	#instantly do damage

func _on_tick():
	enemy.take_damage(damage_per_tick, "Fire")

func end_effect():
	enemy.effect_icon.texture = null
	effect_ended.emit()
	queue_free()
