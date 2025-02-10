extends Node

# Preload scripts for movement modes
var movement_modes = {
	"STAND": preload("res://scripts/move_logic/stand_movement.gd"),
	"WANDER": preload("res://scripts/move_logic/wander_movement.gd"),
	"PATROL": preload("res://scripts/move_logic/patrol_movement.gd"),
	"CHASE": preload("res://scripts/move_logic/chase_movement.gd"),
}

func get_movement_script(mode: String) -> Script:
	return movement_modes.get(mode, null)
