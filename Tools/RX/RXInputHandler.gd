extends GameInputHandler


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("lmb"):
		$Signature.clear_points()
	if Input.is_action_pressed("lmb"):
		$Pen.visible = true
		$Pen.position = Vector2(get_global_mouse_position().x-170,get_global_mouse_position().y-80)
		if $Signature.points.size() > 0:
			# Try not to place down extra points if they're the same as before
			if get_global_mouse_position() != $Signature.points[$Signature.points.size()-1]:
				$Signature.add_point(get_global_mouse_position())
		else:
			$Signature.add_point(get_global_mouse_position())
	elif Input.is_action_just_released("lmb"):
		$Pen.visible = false
		var input_data = RXInputData.new()
		input_data.initialize([$Signature.get_points()])
		emit_signal("input_finished", input_data)
