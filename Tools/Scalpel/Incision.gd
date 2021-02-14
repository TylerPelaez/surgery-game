extends Line2D

signal  calculateDTW(incision_array)

# false if you want to disable the player's ability to draw
onready var can_draw = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	
func reset():
	self.clear_points()
	$AnimationPlayer.play("Fade In")

func enable_draw():
	can_draw = true
	
func times_up():
	$Timer.stop()
	can_draw = false
	emit_signal("calculateDTW", self.get_points())
	$AnimationPlayer.play("Fade Out No Draw")
	# TODO: SFX

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Reset and start the timer
	if Input.is_action_just_pressed("draw") && can_draw:
		$Timer.start(1.5)
	# Draw incision line if mouse is held down 
	if Input.is_action_pressed("draw") && can_draw:
		if self.points.size() > 0:
			# Try not to place down extra points if they're the same as before
			if get_global_mouse_position() != self.points[self.points.size()-1]:
				add_point(get_global_mouse_position())
		else:
			add_point(get_global_mouse_position())
	# If mouse released, signal that DTW should be calculated against current pattern
	if Input.is_action_just_released("draw"):
		$Timer.stop()
		can_draw = false
		if self.points.size() > 0:
			emit_signal("calculateDTW", self.get_points())
		$AnimationPlayer.play("Fade Out")
		# TODO: SFX


func _on_Timer_timeout():
	times_up()
