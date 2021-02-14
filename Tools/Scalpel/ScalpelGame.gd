extends Node

onready var pattern0 = preload("res://Tools/Scalpel/ScalpelPattern0.tscn").instance()
onready var pattern1 = preload("res://Tools/Scalpel/ScalpelPattern1.tscn").instance()
onready var pattern2 = preload("res://Tools/Scalpel/ScalpelPattern2.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Incision.connect("calculateDTW", self, "_on_calculateDTW")
	
	# TODO: In the future the pattern will be randomly selected, and its offset will be randomized
	add_child(pattern0)
	pattern0.show()
	pattern0.set_position(Vector2(-150,150))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_calculateDTW(incision_array):
	# TODO: Programatically determine which patern is being used atm
	var base_array = []
	# Apply positional transform to relative points for the base array
	for i in pattern0.get_points():
		base_array.append(i+pattern0.get_position())
	
	var dtw_array = []
	var euclidean_array = []
	
	# initialize the euclidean distance 2d array
	for i in base_array.size():
		euclidean_array.append([])
		for j in incision_array.size():
			euclidean_array[i].append(base_array[i].distance_to(incision_array[j]))
	
	# initialize dtw distance 2d array
	for i in base_array.size():
		dtw_array.append([])
		for j in incision_array.size():
			dtw_array[i].append(0)
	dtw_array[0][0] = euclidean_array[0][0]

	# implementation found here: https://towardsdatascience.com/an-illustrative-introduction-to-dynamic-time-warping-36aa98513b98
	for i in range(1, base_array.size()):
		dtw_array[i][0] = euclidean_array[i][0] + dtw_array[i-1][0]
	for j in range(1, incision_array.size()):
		dtw_array[0][j] = euclidean_array[0][j] + dtw_array[0][j-1]
	
	for i in range(1, base_array.size()):
		for j in range(1, incision_array.size()):
			var cost = euclidean_array[i][j]
			dtw_array[i][j] = cost + min(dtw_array[i-1][j], min(dtw_array[i][j-1], dtw_array[i-1][j-1]))
