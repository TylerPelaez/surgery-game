extends BaseToolMinigame

# Keep track of rect corner bounds for signature area
const min_corner = Vector2(873,865)
const max_corner = Vector2(1254,970)

# Called when the node enters the scene tree for the first time.
func _ready():
	accepted_tool_type = ToolData.Tools.RX
	BOTCH_DAMAGE = 0
			
	$RXForm.position = scale_vector($RXForm.position)
	$RXForm.scale = scale_vector($RXForm.scale)
			
	if Utils.is_main_scene(self):
		var instance = load("res://Tools/RX/RXInputHandler.tscn").instance()
		instance.connect("input_finished", self, "process_input")
		add_child(instance)

# Given an array of Point2D, make sure array is at least size 75, and 75% of the points are in the specified area
func accept_tool_input(tool_input_data: RXInputData):
	var points_in_bounds = 0
	if tool_input_data.points.size() < 75:
		print("RX Game Botch")
		$Fail.play()
		emit_signal("botch_made", BOTCH_DAMAGE)
	else:
		for point in tool_input_data.points:
			if $RXForm.position_in_bounds(point):
				points_in_bounds += 1
		print("dividing ", points_in_bounds, " by ", tool_input_data.points.size(), " to get ", float(points_in_bounds)/tool_input_data.points.size())
		if float(points_in_bounds)/tool_input_data.points.size() < .75:
			print("RX Game Botch")
			$Fail.play()
			emit_signal("botch_made", BOTCH_DAMAGE)
		else:
			print("RX Game Passed!")
			$Success.play()
			emit_signal("game_finished", true)
