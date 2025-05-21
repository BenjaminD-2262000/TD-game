extends Node3D
class_name Tower

@onready var repair_game = $Repair_Game

var hitbox: Area3D
@export var cost: int
@export var damage: float
@export var max_enemy_hit: int
@export var fire_rate: float  #fire rate in seconds between shot
@export var range: int
@export var level_tree_path: String
var next_level_stats
signal pay_for_upgrade(cost: int)

@onready var tower_location = $Pivot/Tower/RootNode/tower

var current_level: int = 0
var current_enemy: Node3D = null
var enemies_in_range: Array
var placed: bool = false
var broken: bool = false
var repair_in_progress: bool = false

@onready var audioPlayer = $AudioStreamPlayer3D

var setup: bool=false
@export var setup_fase: int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	repair_game.disable_game()
	
	hitbox = $Range
	hitbox.monitoring = true
	hitbox.body_entered.connect(_on_enemy_entered_range)
	hitbox.body_exited.connect(_on_enemy_exit_range)
	
	
	
	#set the range
	var shape = CylinderShape3D.new()
	shape.radius = range
	shape.height = 10
	$Range/CollisionShape3D.set_shape(shape)
	if $Pivot/Tower.has_method("set_transparent"):
		$Pivot/Tower.set_transparent(0.95)
	else:
		$Pivot/Tower.transparency = 0.95
	
	#set mesh to see range
	var mesh = CylinderMesh.new()
	mesh.bottom_radius = range
	mesh.top_radius = range
	mesh.height = 2
	$Range/MeshInstance3D.set_mesh(mesh)
		
	set_next_level_stats(1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage_enemy():
	current_enemy.take_damage(damage)
	audioPlayer.play()

func _on_enemy_entered_range(enemy):
	if not enemy is Enemy or not setup or broken:
		return
	enemy.Enemy_died.connect(_on_enemy_in_range_died)
	if not current_enemy:
		print("set current enemy")
		current_enemy = enemy
		
		if enemy.has_meta("damage_timer"):  #only one timer
			return

		var timer = Timer.new()
		timer.wait_time = fire_rate
		timer.autostart = true
		add_child(timer)

		enemy.set_meta("damage_timer", timer)

		damage_enemy() #instantly handle first tick
		timer.timeout.connect(func():
			if not is_instance_valid(current_enemy):  # ✅ Stop if enemy is gone
				timer.queue_free()
				return  
			damage_enemy()
		)
		
		
		
	else:
		enemies_in_range.push_back(enemy)

func _on_enemy_exit_range(enemy):
	if enemy == current_enemy:
		current_enemy = enemies_in_range.pop_front()
	else:
		enemies_in_range.erase(enemy)


func _on_enemy_in_range_died(enemy, worth):
	if enemy == current_enemy:
		if enemies_in_range[0]:
			current_enemy = enemies_in_range.pop_front()
		else:
			current_enemy = null
	else:
		enemies_in_range.erase(enemy)

func place():
	if $Pivot/Tower.has_method("set_transparent"):
		$Pivot/Tower.set_transparent(0.0)
	else:
		$Pivot/Tower.transparency = 0.0
	$Pivot.position.y -= setup_fase
	$LeverSnap.show()
	$LeverSnap.activate()
	placed = true


func breakdown():
	if placed and setup:
		if $Pivot/Tower.has_method("set_transparent"):
			$Pivot/Tower.set_transparent(0.95)
		else:
			$Pivot/Tower.transparency = 0.95
		broken = true

func handle_wrench():
	if placed and setup:
		if broken and not repair_in_progress:
			repair_in_progress = true
			repair_game.start_repair()
		elif not broken:
			pass
			#TODO: show upgrade screen

func repair():
	if placed and setup and broken:
		if $Pivot/Tower.has_method("set_transparent"):
			$Pivot/Tower.set_transparent(0.0)
		else:
			$Pivot/Tower.transparency = 0.0
		broken = false
		repair_in_progress = false


func _on_lever_snap_full_crank() -> void:
	if not placed:
		return
	if setup_fase > 0:
		setup_fase -= 1
		$Pivot.position.y += 1
	else:
		if $Pivot/Tower.has_method("set_transparent"):
			$Pivot/Tower.set_transparent(0.0)
		else:
			$Pivot/Tower.transparency = 0.0
		setup = true
		remove_child($LeverSnap)


func can_upgrade():
	pass

func show_upgrade_screen():
	var update_screen = XRToolsViewport2DIn3D.new()
	var ui_scene = preload("res://Towers/Upgrade screen.tscn").instantiate()
	ui_scene.hide()
	update_screen.set_scene(ui_scene)
	update_screen.position = Vector3(1, 1.5, 3)
	update_screen.set_stats(next_level_stats)
	add_child(update_screen)
	

func upgrade():
	
	pay_for_upgrade.emit(next_level_stats["price"])
	current_level += 1
	
	damage += next_level_stats["damage"]
	range +=  next_level_stats["range"]
	fire_rate += next_level_stats["fire_rate"]
	max_enemy_hit += next_level_stats["max_enemy_hit"]
	

func set_next_level_stats(next_level: int):
	var file = FileAccess.open(level_tree_path, FileAccess.READ)
	
	if file:
		var json_string = file.get_as_text()
		var level_tree = JSON.parse_string(json_string)
		next_level_stats = level_tree[next_level]
		file.close()

func _on_repair_game_repair_game_done() -> void:
	print("screw bolted")
	repair()


func _on_upgrade_screen_upgrade_confirmed() -> void:
	upgrade()
