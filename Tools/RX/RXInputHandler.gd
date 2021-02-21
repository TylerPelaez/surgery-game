extends GameInputHandler

var writing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_mouse_pos()
	
	if !writing and Input.is_action_just_pressed("lmb") and point_in_viewport(mouse_pos):
		writing = true
		$Scribble.play()
		$Signature.clear_points()
	if writing and Input.is_action_pressed("lmb") and point_in_viewport(mouse_pos):
		$Pen.visible = true
		$Pen.position = mouse_pos
		if $Signature.points.size() > 0:
			# Try not to place down extra points if they're the same as before
			if mouse_pos != $Signature.points[$Signature.points.size()-1]:
				$Signature.add_point(mouse_pos)
		else:
			$Signature.add_point(mouse_pos)
	elif (writing and Input.is_action_just_released("lmb")) or (writing and !point_in_viewport(mouse_pos)):
		writing = false
		$Pen.visible = false
		var input_data = RXInputData.new()
		input_data.initialize([$Signature.get_points()])
		emit_signal("input_finished", input_data)
