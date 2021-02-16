extends ToolInputData
class_name BandageInputData

var start_pos
var end_pos

func initialize(varargs: Array):
	if varargs.size() != 2:
		print("ERROR: BandageInputData given wrongly sized varargs")
	.initialize(ToolData.Tools.Bandage)
	start_pos = varargs[0]
	end_pos = varargs[1]
	game_tool_mismatch_damage = 0
