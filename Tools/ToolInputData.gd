extends Node
class_name ToolInputData

var data_tool_type
# How much damage does using the wrong tool incur?
var game_tool_mismatch_damage = 0

# godot doesn't support function signature overriding, OR varargs ...
func initialize(tool_type):
	data_tool_type = tool_type

func matches_game_type(game_tool_type):
	return data_tool_type == game_tool_type
	
func get_tool_mismatch_damage():
	return game_tool_mismatch_damage
