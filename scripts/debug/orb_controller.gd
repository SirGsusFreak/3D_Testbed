extends Node3D

@export var drag_speed: float = 5.0
var dragging: bool = false
var dragged_object: Node3D = null
var drag_offset: Vector3
var raycast_distance: float = 1000.0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_start_drag()
			else:
				_stop_drag()

func _start_drag():
	var camera = get_viewport().get_camera_3d()
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * raycast_distance
	
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
	
	if result and result.collider is Node3D:
		dragged_object = result.collider
		dragging = true
		drag_offset = result.position - dragged_object.global_transform.origin

func _stop_drag():
	dragging = false
	dragged_object = null

func _process(delta):
	if dragging and dragged_object:
		var camera = get_viewport().get_camera_3d()
		var mouse_position = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_position)
		var to = from + camera.project_ray_normal(mouse_position) * raycast_distance
		
		var space_state = get_world_3d().direct_space_state
		var plane = Plane(Vector3.UP, dragged_object.global_transform.origin)
		var intersection = plane.intersects_ray(from, to)
		
		if intersection:
			var target_position = intersection - drag_offset
			
			# Restrict movement to the x and z directions
			target_position.y = dragged_object.global_transform.origin.y
			
			# Smoothly move the object to the target position
			dragged_object.global_transform.origin = dragged_object.global_transform.origin.lerp(target_position, drag_speed * delta)
