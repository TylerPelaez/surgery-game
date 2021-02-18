extends ToolInputData
class_name SyringeInputData

var color = "none"

func initialize(varargs: Array):
	if varargs.size() != 1:
		print("ERROR: SyringeInputData given wrongly sized varargs")
	.initialize(ToolData.Tools.Syringe)
	color = varargs[0]
	game_tool_mismatch_damage = 5
