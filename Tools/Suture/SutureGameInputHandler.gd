extends LineBasedGameInputHandler
class_name SutureGameInputHandler

var has_intersection = false

func _ready():
	draw_time = 2.0

func start_drawing(mouse_pos):
	$Zipper.play()
	.start_drawing(mouse_pos)

# https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
func on_segment(p: Vector2, q: Vector2, r: Vector2) -> bool:
	if (q.x <= max(p.x, r.x) && q.x >= min(p.x, r.x) &&
		q.y <= max(p.y, r.y) && q.y >= min(p.y, r.y)):
		return true
	return false


# 0 -> p, q, r are co-linear
# 1 -> Clockwise
# 2 -> Counterclockwise
func orientation(p: Vector2, q: Vector2, r: Vector2) -> int:
	var val: int = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)
	if val == 0:
		return 0
	
	return 1 if val > 0 else 2

func lines_intersect(p1: Vector2, q1: Vector2, p2: Vector2, q2: Vector2) -> bool:
	# Get orientations needed for checking general and special cases
	var o1 = orientation(p1, q1, p2)
	var o2 = orientation(p1, q1, q2)
	var o3 = orientation(p2, q2, p1)
	var o4 = orientation(p2, q2, q1)

	# General case!
	if (o1 != o2 && o3 != o4):
		return true

	if (o1 == 0 && on_segment(p1, p2, q1)): return true
	if (o2 == 0 && on_segment(p1, q2, q1)): return true
	if (o3 == 0 && on_segment(p2, p1, q2)): return true
	if (o4 == 0 && on_segment(p2, q1, q2)): return true

	return false

# End spooky intersection math


func draw(mouse_pos):
	if line_2d.points.size() > 0:
		# Try not to place down extra points if they're the same as before
		if mouse_pos != line_2d.points[line_2d.points.size()-1]:
			var prev_point = line_2d.points[line_2d.points.size() - 1]	
			line_2d.add_point(mouse_pos)
			if line_2d.points.size() > 7:
				# skip over the point we just added
				for i in range(1, line_2d.points.size() - 5):
					if lines_intersect(prev_point, mouse_pos, line_2d.points[i - 1], line_2d.points[i]):
						has_intersection = true
						break
	else:
		line_2d.add_point(mouse_pos)
	
func end_drawing(mouse_pos):
	timer.stop()
	if line_2d.points.size() > 0 && can_draw:
		var input_data = SutureInputData.new()
		input_data.initialize([line_2d.get_points(), has_intersection])
		emit_signal("input_finished", input_data)
	if animation_player.playback_active && animation_player.current_animation == FADE_OUT_NO_DRAW_ANIMATION:
		can_draw = true
	else:
		can_draw = false
		animation_player.play(FADE_OUT_ANIMATION)
	# TODO: SFX

func reset():
	has_intersection = false
	.reset()
