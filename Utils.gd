extends Node

var DRAW_DEBUG = false

func instance_scene_on_main(scene: PackedScene, position: Vector2) -> Node:
	var main = get_tree().current_scene
	var instance = scene.instance()
	main.add_child(instance)
	instance.global_position = position
	return instance


func construct_query_params(shape: Shape2D, transform: Transform2D, mask: int = 1, exclude: Array = []) -> Physics2DShapeQueryParameters:
	var query = Physics2DShapeQueryParameters.new()
	query.collide_with_areas = true
	query.set_shape(shape)
	query.set_transform(transform)
	query.exclude = exclude
	query.collision_layer = mask
	query.margin = 1.0
	return query

func shape_cast_would_collide(shape: Shape2D, transform: Transform2D, mask: int = 1):
	var shape_result = shape_cast_get_result(shape, transform, mask)
	if shape_result == null || shape_result.size() == 0:
		return false
	else:
		return true		
		
func shape_cast_get_result(shape: Shape2D, transform: Transform2D, mask: int = 1, exclude: Array = []):
	var space_state = get_tree().current_scene.get_world_2d().direct_space_state
	var query = construct_query_params(shape, transform, mask, exclude)
	var shape_result = space_state.intersect_shape(query)
	return shape_result
