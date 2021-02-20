extends ToolInputData
class_name SutureInputData

var points: PoolVector2Array
var has_intersection: bool

func initialize(varargs):
	if varargs.size() != 2:
		print("ERROR: SutureInputData given wrongly sized varargs")
	.initialize(ToolData.Tools.Suture)
	points = varargs[0]
	has_intersection = varargs[1]
	game_tool_mismatch_damage = 2
