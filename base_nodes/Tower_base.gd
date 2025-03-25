extends Node3D
class_name Tower

@onready var repair_game = $Repair_Game

var hitbox: Area3D
@export var cost: int
@export var damage: int
@export var max_enemy_hit: int
@export var fire_rate: float  #fire rate in seconds between shot
@export var range: int

var current_enemy: Node3D = null
var enemies_in_range: Array
var placed: bool = false
var broken: bool = false
var repair_in_progress: bool = false

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
	$Pivot/Tower/RootNode/tower.transparency = 0.95
	
	#set mesh to see range
	var mesh = CylinderMesh.new()
	mesh.bottom_radius = range
	mesh.top_radius = range
	mesh.height = 2
	$Range/MeshInstance3D.set_mesh(mesh)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage_enemy():
	current_enemy.take_damage(damage)

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


func _on_enemy_in_range_died(enemy):
	if enemy == current_enemy:
		if enemies_in_range[0]:
			current_enemy = enemies_in_range.pop_front()
		else:
			current_enemy = null
	else:
		enemies_in_range.erase(enemy)

func place():
	$Pivot/Tower/RootNode/tower.transparency = 0.90
	$Pivot.position.y -= setup_fase
	$LeverSnap.show()
	$LeverSnap.activate()
	placed = true


func breakdown():
	if placed and setup:
		$Pivot/Tower/RootNode/tower.transparency = 0.95
		broken = true

func start_repair():
	if placed and setup and broken and not repair_in_progress:
		repair_in_progress = true
		repair_game.start_repair()
	
func repair():
	if placed and setup and broken:
		$Pivot/Tower/RootNode/tower.transparency = 0.0
		broken = false
		repair_in_progress = false


func _on_lever_snap_full_crank() -> void:
	if not placed:
		return
	if setup_fase > 0:
		setup_fase -= 1
		$Pivot.position.y += 1
	else:
		$Pivot/Tower/RootNode/tower.transparency = 0.0
		setup = true
		remove_child($LeverSnap)


func _on_repair_game_repair_game_done() -> void:
	print("screw bolted")
	repair()
