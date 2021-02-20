extends LineBasedGameInputHandler

var start_point

func _ready():
	draw_time = 1.0

func start_drawing(mouse_pos):
	.start_drawing(mouse_pos)
	start_point = mouse_pos
	line_2d.add_point(mouse_pos)
	$Rip.play()

func draw(mouse_pos):
	# Snap bandage line to mouse
	if line_2d.points.size() > 1:
		line_2d.remove_point(1)
		line_2d.add_point(mouse_pos)
	else:
		line_2d.add_point(mouse_pos)
	
func end_drawing(mouse_pos):
	timer.stop()
	if line_2d.points.size() == 2 && can_draw:
		var input_data = BandageInputData.new()
		input_data.initialize([start_point, mouse_pos])
		emit_signal("input_finished", input_data)
	if animation_player.playback_active && animation_player.current_animation == FADE_OUT_NO_DRAW_ANIMATION:
		can_draw = true
	else:
		can_draw = false
		animation_player.play(FADE_OUT_ANIMATION)
		# TODO: SFX
