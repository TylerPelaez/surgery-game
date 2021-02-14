extends Line2D

signal  calculateDTW(incision_array)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Draw incision line if mouse is held down 
	if Input.is_action_pressed("draw"):
		if self.points.size() > 0:
			if get_global_mouse_position() != self.points[self.points.size()-1]:
				add_point(get_global_mouse_position())
		else:
			add_point(get_global_mouse_position())
	# If mouse released, signal that DTW should be calculated against current pattern
	if Input.is_action_just_released("draw"):
		emit_signal("calculateDTW", self.get_points())
		# TODO: trigger some kind of fade-out animation to clear the incision
