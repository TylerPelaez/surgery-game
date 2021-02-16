extends LineBasedGameInputHandler
class_name ScalpelGameInputHandler

func _ready():
	draw_time = 1.5

func start_drawing(mouse_pos):
	.start_drawing(mouse_pos)

func draw(mouse_pos):
	if line_2d.points.size() > 0:
		# Try not to place down extra points if they're the same as before
		if mouse_pos != line_2d.points[line_2d.points.size()-1]:
			line_2d.add_point(mouse_pos)
	else:
		line_2d.add_point(mouse_pos)
	
func end_drawing(mouse_pos):
	timer.stop()
	if line_2d.points.size() > 0 && can_draw:
		var input_data = ScalpelInputData.new()
		input_data.initialize([line_2d.get_points()])
		emit_signal("input_finished", input_data)
	if animation_player.playback_active && animation_player.current_animation == FADE_OUT_NO_DRAW_ANIMATION:
		can_draw = true
	else:
		can_draw = false
		animation_player.play(FADE_OUT_ANIMATION)
	# TODO: SFX

func reset():
	.reset()
