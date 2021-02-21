extends ToolInputData
class_name PipetteInputData

func initialize(varargs):
	.initialize(ToolData.Tools.Pipette)
	game_tool_mismatch_damage = varargs
