extends Node

@onready var level_parent = $Level

@export var level: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Console.pause_enabled = true
	Console.add_command("hello_there", hello)
	
	var set_level = level.instantiate()
	level_parent.add_child(set_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hello():
	Console.print_line("General Kenobi!")
