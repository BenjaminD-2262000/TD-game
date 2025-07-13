extends CanvasLayer


signal upgrade_confirmed
signal calcel_upgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_stats(stats):
	$Control/ColorRect/DamageContainer/Right/Stat.text = str(stats["damage"])
	$Control/ColorRect/RangeContainer/Right/Stat.text = str(stats["range"])
	$Control/ColorRect/EnemiesContainer/Right/Stat.text = str(stats["max_enemy_hit"])
	$Control/ColorRect/FireContainer/Right/Stat.text = str(stats["fire_rate"])
	$Control/ColorRect/PriceContainer/Right/Stat.text = str(stats["price"])
	


func _on_upgrade_pressed() -> void:
	upgrade_confirmed.emit()


func _on_cancel_pressed() -> void:
	calcel_upgrade.emit()
