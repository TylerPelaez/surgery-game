extends GameInputHandler

onready var biopsy_needle = $BiopsyNeedle

func _physics_process(delta):
	biopsy_needle.position = get_mouse_pos()

func _on_BiopsyNeedle_complete():
	var inputData = BiopsyNeedleInputData.new()
	inputData.initialize(null)
	emit_signal("input_finished", inputData)
