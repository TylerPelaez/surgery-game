extends ToolInputData
class_name PipetteInputData

func initialize(varargs):
	if varargs.size() != 0:
		print("ERROR: PipetteInputData given wrongly sized varargs")
	.initialize(ToolData.Tools.Pipette)
	game_tool_mismatch_damage = 1
	
func _process(delta):
	game_tool_mismatch_damage = 1 * delta
