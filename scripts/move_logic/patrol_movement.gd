extends Node

@export var patrol_points: Array[Vector3] = []
@export var speed: float = 2.5
var _current_index: int = 0

func move(_delta: float) -> void:
	if patrol_points.size() == 0:
		return

	var target = patrol_points[_current_index]
	var direction = (target - owner.global_transform.origin).normalized()
	owner.move_and_slide(direction * speed)

	if owner.global_transform.origin.distance_to(target) < 0.5:
		_current_index = (_current_index + 1) % patrol_points.size()
