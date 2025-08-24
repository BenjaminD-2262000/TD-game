extends PathFollow3D
class_name Enemy_Base

@export var health: int = 100
@export var speed: float = 10.0
@export var damage: float = 1.0
@export var resistances: Dictionary = {}
@export var worth: int = 10
@export var armored: bool = false
@onready var effect_icon = $CharacterBody3D/SubViewport/HPBar/StatusEffect
var active_effects = []  # List to track status effects

signal reached_end

signal enemy_died(worth: int)


# Called when the node enters the scene tree for the first time.
func _ready():
	$CharacterBody3D/SubViewport/HPBar/HPBarTexture.max_value = health
	$CharacterBody3D/SubViewport/HPBar/HPBarTexture.value = health
	if $CharacterBody3D/Model.has_method("play_animation"):
		$CharacterBody3D/Model.play_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress += speed * delta
	
	if progress_ratio >= 1.0:  #canot be to precise
		reached_end.emit(self)

func take_damage(amount: int, type: String = "normal"):
	#Armored enemies are immune to standard attacks
	if armored and type == "normal":
		return
	health -= amount
	$CharacterBody3D/SubViewport/HPBar/HPBarTexture.value = health
	$CharacterBody3D/SubViewport/HPBar/HPBarTexture.queue_redraw()
	if health <=0:
		die()
	
		

func die():
	$AudioStreamPlayer3D.play()
	enemy_died.emit(worth)
	$CharacterBody3D.Enemy_died.emit(worth)
	queue_free()


func apply_status_effect(effect: StatusEffect):
	# Prevent duplicate effects of the same type (e.g., only one burning effect at a time)
	for e in active_effects:
		if e.get_class() == effect.get_class():
			return  
	
	effect_icon.texture = effect.effect_symbol
	effect.effect_ended.connect(remove_effect)
	add_child(effect)
	active_effects.append(effect)


#for flame thrower and flame towers
func set_on_fire(time: float, damage: float):
	var fire_effect = BurningEffect.new(self, time, damage)
	apply_status_effect(fire_effect)


func freeze(time: float, slowness_multiplayer: float):
	var freeze_effect = FreezeEffect.new(self, time, slowness_multiplayer)
	apply_status_effect(freeze_effect)

func _on_character_body_3d_enemy_hit(damage):
	take_damage(damage)
	
func remove_effect(effect):
	active_effects.erase(effect)
