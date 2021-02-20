extends BaseToolMinigame

const POTENTIAL_BIOPSY_POSITION_RADIUS = 200
const OrganScene = preload("res://Tools/BiopsyNeedle/BiopsyOrgan.tscn")

var organ_instance

func _ready():
	accepted_tool_type = ToolData.Tools.BiopsyNeedle
	BOTCH_DAMAGE = 0
	
	for child in get_children():
		print(get_x_scale_factor())
		child.position = Vector2(child.position.x * get_x_scale_factor(), child.position.y * get_y_scale_factor())
	
	var viewport_rect = get_viewport().get_visible_rect()
	var center_point = (viewport_rect.end + get_viewport_rect().position) / 2.0
	
	# This is basically polar coordinates
	var theta_direction = Vector2(randf(), randf()).normalized()
	var organ_position = center_point + (theta_direction * POTENTIAL_BIOPSY_POSITION_RADIUS)
	
	organ_instance = OrganScene.instance()
	organ_instance.position = organ_position
	add_child(organ_instance)
	
	if Utils.is_main_scene(self):
		var instance = load("res://Tools/BiopsyNeedle/BiopsyNeedleGameInputHandler.tscn").instance()
		instance.connect("input_finished", self, "process_input")
		add_child(instance)

func accept_tool_input(tool_input_data: BiopsyNeedleInputData):
	emit_signal("game_finished", true)
