extends Node

@export_enum("Stand", "Wander", "Patrol") var base_move: String = "Stand"
@export_enum("Guard", "Chase", "Flee") var aggro_move: String = "Guard"

@export_range(0, 5.0) var base_speed: float = 1
@export_range(0, 5.0) var aggro_speed: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var base_movement_node = Node.new()
	base_movement_node.name = "BaseLogic"
	base_movement_node.set_script(MovementDict.get_movement_script(base_move.to_upper()))
	base_movement_node.speed = base_speed
	add_child(base_movement_node)
	
	var aggro_movement_node = Node.new()
	aggro_movement_node.name = "AggroLogic"
	aggro_movement_node.set_script(MovementDict.get_movement_script(aggro_move.to_upper()))
	aggro_movement_node.speed = aggro_speed
	add_child(aggro_movement_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_base_move() -> String:
	return base_move

func get_aggro_move() -> String:
	return aggro_move
