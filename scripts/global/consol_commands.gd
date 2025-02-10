extends Node

var command_dict: Dictionary = {
	
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Console.add_command("debug_vis_show", show_debug_vis, [""])
	Console.add_command("test", console_test, ["param1", "param2"], 1, "Test Command")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_debug_vis():
	Console.print_line("Debug Visuals")

func console_test():
	Console.print_line("")
