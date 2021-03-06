extends Node2D
class_name BaseToolMinigame

signal game_finished(result)
signal botch_made(damage)
signal health_item_used(amount)

var BOTCH_DAMAGE
var accepted_tool_type

func process_input(tool_input_data: ToolInputData):
	if tool_input_data.matches_game_type(accepted_tool_type):
		accept_tool_input(tool_input_data)
	elif tool_input_data is DefibrillatorToolInputData:
		emit_signal("health_item_used", 60)
	elif tool_input_data is AdenosineToolInputData:
		emit_signal("health_item_used", -60)
	else:
		$Fail.play()
		emit_signal("botch_made", tool_input_data.get_tool_mismatch_damage())

func process_botch(damage):
	emit_signal("botch_made", damage)

func accept_tool_input(tool_input_data):
	pass

func scale_vector(vector):
	return Vector2(vector.x * get_x_scale_factor(), vector.y * get_y_scale_factor())

func get_x_scale_factor():
	return get_viewport().get_visible_rect().size.x / get_tree().current_scene.get_viewport().get_visible_rect().size.x

func get_y_scale_factor():
	return get_viewport().get_visible_rect().size.y / get_tree().current_scene.get_viewport().get_visible_rect().size.y
