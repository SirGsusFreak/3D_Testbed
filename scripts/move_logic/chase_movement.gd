extends Node

@export var target: NodePath  # Assign the player or target node

@export var speed: float = 3.0
@export var home_range: float = 10.0  # Distance from the spawn point
@export var home_sick: bool = false

var _spawn_position: Vector3  # Initial position of the enemy
var _target_direction: Vector3  # Direction the enemy wants to face/walk
var _facing_angle: float = 0.0  # Current facing angle (in radians)
var _state: String = "walking"  # State: "walking", "standing", or "turning"
var _timer: float = 0.0  # Timer for current state

func move(_delta: float) -> void:
	var target_node = get_node_or_null(target)
	if target_node:
		var direction = (target_node.global_transform.origin - owner.global_transform.origin).normalized()
		owner.move_and_slide(direction * speed)
