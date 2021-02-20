extends ToolInputData
class_name SyringeInputData

var syringe_to_node_map = { Syringe.FluidColor.BLUE: "blue", Syringe.FluidColor.YELLOW: "yellow", Syringe.FluidColor.PINK: "pink" }

var color = "none"

func initialize(varargs: Array):
	if varargs.size() != 1:
		print("ERROR: SyringeInputData given wrongly sized varargs")
	.initialize(ToolData.Tools.Syringe)
	
	if (syringe_to_node_map.has(varargs[0])):
		color = syringe_to_node_map[varargs[0]]
	game_tool_mismatch_damage = 10
