extends Node

@export var speed: float = 2.0
@export var home_range: float = 10.0  # Distance from the spawn point
@export var stand_duration_range: Vector2 = Vector2(1.0, 2.0)  # Min and max standing time
@export var walk_duration_range: Vector2 = Vector2(2.0, 3.5)  # Min and max walking time
@export var home_sick: bool = false

var _spawn_position: Vector3  # Initial position of the enemy
var _target_direction: Vector3  # Direction the enemy wants to face/walk
var _facing_angle: float = 0.0  # Current facing angle (in radians)
var _state: String = "walking"  # State: "walking", "standing", or "turning"
var _timer: float = 0.0  # Timer for current state


func _ready():
	self.set_owner(get_parent().get_parent())
	_spawn_position = owner.global_transform.origin
	_set_random_target_direction()
	owner.connect("home_sick", set_home_sick)


func move(delta: float):
	_update_target_arrow()
	
	match _state:
		"walking":
			_handle_walking(delta)
		"standing":
			_handle_standing(delta)
		"turning":
			_handle_turning(delta)


# Updates the target arrow in the Enemy class
func _update_target_arrow():
	if owner.has_node("DebugArrows/TargetArrow"):
		var target_arrow = owner.get_node("DebugArrows/TargetArrow")
		target_arrow.set_direction(_target_direction)


func _target_arrow_color(color: Color):
	if not owner.has_node("DebugArrows/TargetArrow"):
		return
	var target_arrow: DebugArrowRay = owner.get_node("DebugArrows/TargetArrow")
	target_arrow.set_color(color)


func _handle_walking(delta: float):
	# Move in the current target direction
	var direction = Vector3(cos(_facing_angle), 0, sin(_facing_angle)).normalized()
	owner.velocity = direction * speed
	var collision = owner.move_and_slide()

	# Check for collision and reflect movement
	if collision and owner.get_slide_collision_count() > 0:
		var collision_info = owner.get_slide_collision(0)
		var normal = collision_info.get_normal()
		_target_direction = _target_direction.bounce(normal)  # Reflect direction
		_facing_angle = atan2(_target_direction.z, _target_direction.x)
		_update_target_arrow()  # Update the arrow to reflect new direction
		_state = "turning"  # Go into turning state after a collision

	# Countdown timer
	if home_sick:
		_target_home()
		_state = "turning"
		return
	
	_timer -= delta
	if _timer <= 0.0:
		_target_arrow_color(Color(0, 1, 0))
		if randi() % 3 == 0: # Decide to stand or turn
			_state = "standing"
			_timer = randf_range(stand_duration_range.x, stand_duration_range.y)
		else:  # Turn while walking
			_state = "turning"
			_set_random_turn_direction()


func _handle_standing(delta: float):
	# Stand still and wait
	_timer -= delta
	
	owner.velocity = Vector3.ZERO
	owner.move_and_slide()
	
	if _timer <= 0.0:
		_state = "turning"
		_set_random_turn_direction()


func _handle_turning(delta: float):
	# Smoothly turn the facing angle towards the target direction
	var target_angle = atan2(_target_direction.z, _target_direction.x)
	var angle_dif = wrapf(target_angle - _facing_angle, -PI, PI)

	# Turn speed (adjust the 2.0 for faster/slower turns)
	var turn_speed = 2.0 * delta
	if abs(angle_dif) > turn_speed:
		_facing_angle += sign(angle_dif) * turn_speed
	else:
		_facing_angle = target_angle
		_state = "walking"
		if not home_sick and _timer <= 0.0:
			_timer = randf_range(walk_duration_range.x, walk_duration_range.y)
	
	owner.global_rotation.y = -_facing_angle  # Adjust enemy's global rotation
	var direction = Vector3(cos(_facing_angle), 0, sin(_facing_angle)).normalized()
	owner.velocity = direction * speed
	owner.move_and_slide()


func _target_home():
	var direction_to_home = (_spawn_position - owner.global_transform.origin).normalized()
	_target_direction = direction_to_home


func _set_random_target_direction():
	# Choose a random angle between -135 and 135 degrees relative to the current facing angle
	var turn_angle = deg_to_rad(randf_range(-135, 135))
	var new_angle = _facing_angle + turn_angle
	_target_direction = Vector3(cos(new_angle), 0, sin(new_angle)).normalized()


func _set_random_turn_direction():
	# Randomly decide to turn or go straight
	if randi() % 4 == 0:  # 1 in 4 chance to keep going straight
		_target_direction = Vector3(cos(_facing_angle), 0, sin(_facing_angle)).normalized()
	else:
		_set_random_target_direction()


func set_home_sick(value: bool):
	home_sick = value
	handle_home_sick_change()


func handle_home_sick_change():
	if home_sick:
		_target_arrow_color(Color(0, 0.5, 1))
		_target_home()
		_timer = 0.0
		_state = "turning"
	else:
		_timer = 3.0
