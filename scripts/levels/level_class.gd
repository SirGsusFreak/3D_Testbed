extends Node
class_name Level

@onready var grunt = $Grunt
@onready var active_target_label = $Control/GridContainer/VBoxContainer/FPSLabel
@onready var fps_label = $Control/GridContainer/VBoxContainer/FPSLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var active_target = grunt.active_target
	active_target_label.text = "Active Target: " + (active_target.name if active_target else "None")
	
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
