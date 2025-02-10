@tool
extends Marker3D
class_name DebugArrowRay

## Debug arrow ray
# origin: Vector3,
# direction: Vector3,
# length: float,
# color: Color = Color(0, 0, 0, 0),
# arrow_size: float = 0.5,
# is_absolute_size: bool = false,
# duration: float = 0

@export var use_global_direction: bool = false
@export var direction: Vector3 = Vector3(0, 0, 1)
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var length: float = 2
@export var color: Color = Color(1.0, 1.0, 1.0)
@export var arrow_size: float = 0.25
@export var is_absolute_size: bool = true
@export var duration: float = 0

@export_category("Render")
@export_flags_3d_render var layer: int

var parent: GeometryInstance3D

func _ready() -> void:
	if owner:
		parent = owner.get_node("DebugArrows")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if check_visibility():
		var rotated_direction: Vector3
		if use_global_direction:
			rotated_direction = direction.normalized()
		else:
			rotated_direction = (global_transform.basis * direction).normalized()
		
		DebugDraw3D.draw_arrow_ray(
			global_transform.origin, 
			rotated_direction * length,
			1,
			color,
			arrow_size,
			is_absolute_size,
			duration
		)

func get_direction() -> Vector3:
	return direction

func set_direction(new_direction: Vector3) -> void:
	self.direction = new_direction

func get_color() -> Color:
	return color

func set_color(color: Color) -> void:
	self.color = color

func check_visibility() -> bool:
	if not visible:
		return false
	elif parent and not parent.visible:
		return false
	elif owner and not owner.visible:
		return false
	else:
		return true
