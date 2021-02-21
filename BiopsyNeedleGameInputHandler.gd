extends GameInputHandler

onready var biopsy_needle = $BiopsyNeedle

var button_pressed

var botch_damage = 5

func _physics_process(delta):
	if !button_pressed and Input.is_action_just_pressed("lmb"):
		button_pressed = true
		biopsy_needle.enable_collision()
		$Squish.play()
	
	if button_pressed:
		if Input.is_action_just_released("lmb"):
			button_pressed = false
			biopsy_needle.disable_collision()
		elif Input.is_action_pressed("lmb") and !biopsy_needle.is_in_organ():
			$Fail.play()
			emit_signal("do_botch", botch_damage * delta)
	
	biopsy_needle.position = get_mouse_pos()

func _on_BiopsyNeedle_complete():
	var inputData = BiopsyNeedleInputData.new()
	inputData.initialize(null)
	emit_signal("input_finished", inputData)
