extends BaseToolMinigame

const patterns = [
	preload("res://Tools/Scalpel/Patterns/ScalpelPattern0.tscn"),
	preload("res://Tools/Scalpel/Patterns/ScalpelPattern1.tscn"),
	preload("res://Tools/Scalpel/Patterns/ScalpelPattern2.tscn"),
	preload("res://Tools/Scalpel/Patterns/ScalpelPattern3.tscn"),
	preload("res://Tools/Scalpel/Patterns/ScalpelPattern4.tscn")
]

const dotted_line_texture = preload("res://Tools/Scalpel/Dottedline.png")

onready var pattern_to_use

const acceptable_dtw = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	accepted_tool_type = ToolData.Tools.Scalpel
	
	BOTCH_DAMAGE = 10
	
	# Pick a pattern at random to use
	var pattern_index = randi() % patterns.size()
	pattern_to_use = patterns[pattern_index].instance()
	add_child(pattern_to_use)
	pattern_to_use.width = 30
	pattern_to_use.texture = dotted_line_texture
	pattern_to_use.texture_mode = Line2D.LINE_TEXTURE_TILE

	pattern_to_use.show()

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	# Randomize the position of the pattern
	var y_offset = rng.randi_range(-150, 150)
	var x_offset = rng.randi_range(-150, 150)
	pattern_to_use.set_position(Vector2(x_offset,y_offset))
	
	if Utils.is_main_scene(self):
		var instance = load("res://Tools/Scalpel/ScalpelGameInputHandler.tscn").instance()
		instance.connect("input_finished", self, "process_input")
		add_child(instance)
		
func accept_tool_input(tool_input_data: ScalpelInputData):
	_on_calculateDTW(tool_input_data.points)
	
func _on_calculateDTW(incision_array):
	var base_array = []
	var base_array_reversed = []
	# Apply positional transform to relative points for the base array
	for i in pattern_to_use.get_points():
		base_array.append(i+pattern_to_use.get_position())
	for i in range(pattern_to_use.get_points().size()-1, -1, -1):
		base_array_reversed.append(pattern_to_use.get_points()[i]+pattern_to_use.get_position())
	
	var dtw_array = []
	var dtw_array_reversed = []
	var euclidean_array = []
	var euclidean_array_reversed = []
	
	# initialize the euclidean distance 2d array
	for i in base_array.size():
		euclidean_array.append([])
		for j in incision_array.size():
			euclidean_array[i].append(base_array[i].distance_to(incision_array[j]))
	
	for i in base_array_reversed.size():
		euclidean_array_reversed.append([])
		for j in incision_array.size():
			euclidean_array_reversed[i].append(base_array_reversed[i].distance_to(incision_array[j]))
	
	# initialize dtw distance 2d array
	for i in base_array.size():
		dtw_array.append([])
		for j in incision_array.size():
			dtw_array[i].append(0)
	dtw_array[0][0] = euclidean_array[0][0]
	
	for i in base_array_reversed.size():
		dtw_array_reversed.append([])
		for j in incision_array.size():
			dtw_array_reversed[i].append(0)
	dtw_array_reversed[0][0] = euclidean_array_reversed[0][0]

	# implementation found here: https://towardsdatascience.com/an-illustrative-introduction-to-dynamic-time-warping-36aa98513b98
	for i in range(1, base_array.size()):
		dtw_array[i][0] = euclidean_array[i][0] + dtw_array[i-1][0]
	for j in range(1, incision_array.size()):
		dtw_array[0][j] = euclidean_array[0][j] + dtw_array[0][j-1]
		
	for i in range(1, base_array_reversed.size()):
		dtw_array_reversed[i][0] = euclidean_array_reversed[i][0] + dtw_array_reversed[i-1][0]
	for j in range(1, incision_array.size()):
		dtw_array_reversed[0][j] = euclidean_array_reversed[0][j] + dtw_array_reversed[0][j-1]
	
	for i in range(1, base_array.size()):
		for j in range(1, incision_array.size()):
			var cost = euclidean_array[i][j]
			dtw_array[i][j] = cost + min(dtw_array[i-1][j], min(dtw_array[i][j-1], dtw_array[i-1][j-1]))
			
	for i in range(1, base_array_reversed.size()):
		for j in range(1, incision_array.size()):
			var cost = euclidean_array_reversed[i][j]
			dtw_array_reversed[i][j] = cost + min(dtw_array_reversed[i-1][j], min(dtw_array_reversed[i][j-1], dtw_array_reversed[i-1][j-1]))
		
	var min_dtw = min(dtw_array[base_array.size()-1][incision_array.size()-1], dtw_array_reversed[base_array_reversed.size()-1][incision_array.size()-1])
#	print("DTW IS:", min_dtw)
	if min_dtw <= acceptable_dtw:
		print("Scalpel minigame passed!")
		emit_signal("game_finished", true)
	else:
		print("Scalpel minigame failed!")
		emit_signal("botch_made", BOTCH_DAMAGE)
