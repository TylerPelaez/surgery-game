extends Node2D
class_name GameInputHandler

signal input_finished(tool_input_data)

func get_mouse_pos():
	return get_viewport().get_parent().get_local_mouse_position() if get_viewport().get_parent() != null else get_global_mouse_position()
