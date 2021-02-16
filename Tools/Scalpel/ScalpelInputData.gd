extends ToolInputData
class_name ScalpelInputData

var points: PoolVector2Array

func initialize(varargs):
	if varargs.size() != 1:
		print("ERROR: ScalpelInputData given wrongly sized varargs")
	.initialize(ToolData.Tools.Scalpel)
	points = varargs[0]
	game_tool_mismatch_damage = 5
