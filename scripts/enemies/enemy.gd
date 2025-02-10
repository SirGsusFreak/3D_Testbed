extends CharacterBody3D

class_name Enemy

@export var enemy_type_name: String 

@export var health: int = 100
@export var active_target: Node3D
@export var engaged: bool = false
@export var current_mode: String
@export var active_radius: int = 50
@export var active: bool = true


@export_group("Home")
@onready var home_point: Node3D = $Home/HomePoint
var home: Vector3
@export var home_range: int = 10
@onready var home_area: Area3D = $Home/HomeArea
@onready var home_collision: CollisionShape3D = $Home/HomeArea/HomeCollision
@export_subgroup("Debug")
@onready var home_debug_vis: MeshInstance3D = $Home/HomeArea/HomeCollision/HomeDebugVisual

@export_group("Logic")
@export var current_move_mode: String
@export var current_move_script: Script
var base_logic: String
var aggro_logic: String
@onready var movement_node: Node = $MovementLogic
@onready var facing_arrow: DebugArrowRay = $DebugArrows/FacingArrow
@onready var target_arrow: DebugArrowRay = $DebugArrows/TargetArrow
@onready var base_move_node: Node = $MovementLogic/BaseLogic
@onready var aggro_move_node: Node = $MovementLogic/AggroLogic

@export_group("Aggro")
@export var is_aggro: bool = false
@export var can_aggro: bool = true
#@export var home_sick: bool = false
@export var aggro_range: int = 5
@export var target_array: Array[Node3D]
@onready var aggro_area: Area3D = $AggroArea
@onready var aggro_bounds: CollisionShape3D = $AggroArea/AggroShape
@export_subgroup("Debug")
@onready var aggro_debug_vis: MeshInstance3D = $AggroArea/AggroShape/AggroDebugVisual

@export_group("Debugging")
@export var debug_visibility: bool = false
@export var view_home_point: bool = true
@export var view_home_range: bool = true
@export var view_aggro_range: bool = true
@export var view_facing_arrow: bool = true
@export var view_target_arrow: bool = true


@onready var debug_dictionary: Dictionary = {
	"$Home/HomePoint/HomeDebugPoint": view_home_point,
	"$Home/HomeArea/HomeCollision/HomeDebugVisual": view_home_range,
	"$AggroArea/AggroShape/AggroDebugVisual": view_aggro_range,
	"$FacingArrow": view_facing_arrow,
	"$TargetArrow": view_target_arrow,
}

var facing_angle: float

signal home_sick(bool)
signal died

func _ready():
	home = global_transform.origin
	home_collision.transform.scaled(Vector3(home_range, home_collision.scale.y, home_range))
	
	base_logic = movement_node.get_base_move()
	aggro_logic = movement_node.get_aggro_move()
	
	active_target = null
	
	Signalbus.connect("is_debug_active", debug_vis)


func _process(delta: float) -> void:
	target_check()
	update_target_arrow()


func _physics_process(delta: float) -> void:
	move(delta)


#func set_target(new_target: Node3D) -> void:
	#active_target = new_target


func update_target_arrow() -> void:
	#var target_dir = (target.position - global_transform.origin).normalized()
	#target_arrow.set_direction(target_dir)
	pass


func debug_vis():
	for path in debug_dictionary:
		var node = get_node_or_null(path)  # Safely get the node
		print(node)
		if node:
			if debug_visibility:
				node.visible = debug_dictionary[path]
				print("Debug Node ", path, " visible: ", debug_dictionary[path])
			else: node.visible = false
		else:
			push_error("Error: Node at path ", path, " not found!")


func move(delta: float):
	if is_aggro and can_aggro:
		run_aggro_logic(delta)
	else:
		run_base_logic(delta)


func run_base_logic(delta: float):
	if base_move_node and base_move_node.has_method("move"):
		base_move_node.move(delta)
	else:
		push_error("Base movement script is missing or improperly configured.")


func run_return_home_logic(delta: float):
	if base_move_node and base_move_node.has_method("move"):
		base_move_node.return_home(delta)


func run_aggro_logic(delta: float):
	if aggro_move_node and aggro_move_node.has_method("move"):
		target_arrow.color = Color(1, 0, 0)
		aggro_move_node.target = active_target
		aggro_move_node.move(delta)
	else:
		push_error("Aggro movement script is missing or improperly configured.")


func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()


func die():
	emit_signal("died")
	queue_free()


func _on_home_area_exited(body: Node3D) -> void:
	print("Home Exited")
	if body != self:
		return
	print("Enemy is home sick")
	is_aggro = false; can_aggro = false
	emit_signal("home_sick", true)
	active_target = home_point

func _on_home_area_entered(body: Node3D) -> void:
	print("Home Entered")
	if body != self:
		return
	print("Enemy is has returned home")
	can_aggro = true
	emit_signal("home_sick", false)


func target_check():
	if target_array.is_empty():
		engaged = false
		active_target = null
		return
	
	if not engaged || active_target == null:
		assign_active_target()


func assign_active_target() -> void:
	if target_array.is_empty():
		active_target = null
		return  # No targets to assign

	var closest_distance = INF  # Initialize to a very large value
	var closest_target: Node3D = null

	for target in target_array:
		if not is_instance_valid(target):
			continue  # Skip invalid targets

		var distance = global_transform.origin.distance_to(target.global_transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			closest_target = target

	active_target = closest_target  # Assign the closest target
	


func _on_aggro_area_body_entered(body: Node3D) -> void:
	target_array.append(body)
	pass # Replace with function body.
