extends ToolInputData
class_name RXInputData

var points: PoolVector2Array

func initialize(varargs):
	if varargs.size() != 1:
		print("ERROR: RXInputData given wrongly sized varargs")
	.initialize(ToolData.Tools.RX)
	points = varargs[0]
	game_tool_mismatch_damage = 10
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
