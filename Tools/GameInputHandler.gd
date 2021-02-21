extends Node2D
class_name GameInputHandler

signal input_finished(tool_input_data)
signal do_botch(damage)

func get_mouse_pos():
	return get_viewport().get_parent().get_local_mouse_position() if get_viewport().get_parent() != null else get_global_mouse_position()

func point_in_viewport(point):
	return get_viewport().get_visible_rect().has_point(point)

func get_x_scale_factor():
	return get_viewport().get_visible_rect().size.x / get_tree().current_scene.get_viewport().get_visible_rect().size.x

func get_y_scale_factor():
	return get_viewport().get_visible_rect().size.y / get_tree().current_scene.get_viewport().get_visible_rect().size.y
