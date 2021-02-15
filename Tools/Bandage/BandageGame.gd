extends BaseToolMinigame

onready var pattern0 = preload("res://Tools/Bandage/BandagePattern0.tscn").instance()
onready var pattern1 = preload("res://Tools/Bandage/BandagePattern1.tscn").instance()
onready var pattern2 = preload("res://Tools/Bandage/BandagePattern2.tscn").instance()
onready var pattern3 = preload("res://Tools/Bandage/BandagePattern3.tscn").instance()

onready var patterns = []
onready var pattern_to_use

const acceptable_radius = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	$Bandage.connect("calculateBandage", self, "_on_calculateBandage")
	
	# Pick a pattern at random to use
	patterns.append(pattern0)
	patterns.append(pattern1)
	patterns.append(pattern2)
	patterns.append(pattern3)
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var pattern_number = rng.randi_range(0, 3)
	
	if pattern_number == 0:
		pattern_to_use = pattern0
	if pattern_number == 1:
		pattern_to_use = pattern1
	if pattern_number == 2:
		pattern_to_use = pattern2
	if pattern_number == 3:
		pattern_to_use = pattern3

	add_child(pattern_to_use)
	pattern_to_use.show()
	# Randomize the position of the pattern
	var y_offset = rng.randi_range(-75, 75)
	var x_offset = rng.randi_range(-150, 150)
	pattern_to_use.set_position(Vector2(x_offset,y_offset))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Compare the player's bandage against the template pattern
func _on_calculateBandage(start_point, end_point):
#	print("Calculating Bandage Game")
	# Auto-fail if player bandage somehow does not have 2 points
	if start_point == null || end_point == null:
#		print("Bandage minigame failed! Invalid player line!")
		emit_signal("botch_made", 0)
		return
	
	# Coordinates of the template line start and end points
	# Making sure to account for the offset
	var pattern_start = pattern_to_use.get_points()[0] + pattern_to_use.get_position()
	var pattern_end = pattern_to_use.get_points()[1] + pattern_to_use.get_position()
	
	# Check to see if the first point of the player bandage is within the acceptable radius of the template points
	# Check both directions the line could be drawn in
	var radius1 = start_point.distance_to(pattern_start)
	var radius2 = end_point.distance_to(pattern_end)
	var radius3 = end_point.distance_to(pattern_start)
	var radius4 = start_point.distance_to(pattern_end)
	
#	print("Radius check: ", radius1, ", ", radius2, ", ", radius3, ", ", radius4)
	if (radius1 <= acceptable_radius && radius2 <= acceptable_radius) || (radius3 <= acceptable_radius && radius4 <= acceptable_radius):
#		print("Bandage minigame success!")
		emit_signal("game_finished", true)
	else:
#		print("Bandage minigame failed!")
		emit_signal("botch_,made", 0)
	
