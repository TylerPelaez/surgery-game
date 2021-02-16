extends Line2D

signal calculateBandage(start_point, end_point)

# false if you want to disable the player's ability to draw
onready var can_draw = true

# Keep track of start and end points
onready var start_point
onready var end_point

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset():
	self.clear_points()
	modulate = Color.white
	
func enable_draw():
	can_draw = true
	
func times_up():
	$Timer.stop()
	if can_draw && self.points.size() == 2:
		emit_signal("calculateBandage", start_point, end_point)
	can_draw = false
	$AnimationPlayer.play("Fade Out No Draw")
	# TODO: SFX
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_viewport().get_parent().get_local_mouse_position() if get_viewport().get_parent() != null else get_global_mouse_position()
	# Reset and start the timer
	if Input.is_action_just_pressed("draw"):
		$Timer.start(1)
		start_point = mouse_pos
		self.add_point(mouse_pos)
	# Snap bandage line to mouse
	if Input.is_action_pressed("draw") && can_draw:
		if self.points.size() > 1:
			self.remove_point(1)
			self.add_point(mouse_pos)
		else:
			 self.add_point(mouse_pos)
		end_point = mouse_pos
	# If mouse released, signal that bandage placement should be calculated
	if Input.is_action_just_released("draw"):
		$Timer.stop()
		end_point = mouse_pos
		if self.points.size() == 2 && can_draw:
			emit_signal("calculateBandage", start_point, end_point)
		if $AnimationPlayer.playback_active && $AnimationPlayer.current_animation == "Fade Out No Draw":
			can_draw = true
		else:
			can_draw = false
			$AnimationPlayer.play("Fade Out")
		# TODO: SFX

func _on_Timer_timeout():
	times_up()
