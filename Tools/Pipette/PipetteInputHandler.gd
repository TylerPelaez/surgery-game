extends GameInputHandler


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Pipette.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_mouse_pos()
	if Input.is_action_pressed("lmb") and get_viewport().get_visible_rect().has_point(mouse_pos):
		$Pipette.visible = true
		$Pipette.position = Vector2(mouse_pos.x + 175, mouse_pos.y - 210)
		var input_data = PipetteInputData.new()
		input_data.initialize(delta)
		emit_signal("input_finished", input_data)
		# TODO: SFX
	else:
		$Pipette.visible = false
