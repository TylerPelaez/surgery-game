extends Node2D
class_name BaseToolMinigame

signal game_finished(result)
signal botch_made(damage)

var BOTCH_DAMAGE
var accepted_tool_type

func process_input(tool_input_data: ToolInputData):
	if tool_input_data.matches_game_type(accepted_tool_type):
		accept_tool_input(tool_input_data)
	else:
		emit_signal("botch_made", tool_input_data.get_tool_mismatch_damage())

func accept_tool_input(tool_input_data):
	pass
