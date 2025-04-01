extends Node
class_name StatusEffect

var duration: float = 0.0
var enemy: Enemy_Base  # The enemy this effect applies to
var effect_symbol

signal effect_ended

func _init(_enemy, _duration):
	enemy = _enemy
	duration = _duration

# Called every second (or a defined interval)
func apply_effect():
	pass  # To be implemented by subclasses

# Called when the effect ends
func end_effect():
	effect_ended.emit()
	queue_free()
