extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	DebugDraw3D.draw_cylinder_ab(Vector3(1,1,1), Vector3(1,1,1), 1, Color(1,0,0))
