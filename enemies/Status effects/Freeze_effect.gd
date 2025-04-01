extends StatusEffect
class_name FreezeEffect

var original_enemy_speed: float
var slowness_multiplayer: float


func _init(_enemy, _duration, _slowness_multiplayer):
	super(_enemy, _duration)
	slowness_multiplayer = _slowness_multiplayer
	effect_symbol = preload("res://enemies/Freeze.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_effect()  # Apply the first tick immediately
	var time_left_on_frozen = Timer.new()
	time_left_on_frozen.wait_time = duration
	time_left_on_frozen.autostart = true
	time_left_on_frozen.one_shot = false
	add_child(time_left_on_frozen)
	time_left_on_frozen.timeout.connect(end_effect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func apply_effect():
	original_enemy_speed = enemy.speed
	enemy.speed = enemy.speed * slowness_multiplayer

func end_effect():
	enemy.speed = original_enemy_speed
	enemy.effect_icon.texture = null
	effect_ended.emit()
	queue_free()
