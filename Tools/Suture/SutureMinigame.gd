extends BaseToolMinigame

onready var wound_line = $Line2D

var firstPoint
var center_pos
var secondPoint
var midpoint
var maxDistanceFromMidpoint


const SUTURE_DRAW_RADIUS = 200
const REQUIRED_SIDE_CHANGE_COUNT = 4

func _ready():
	randomize()
	
	BOTCH_DAMAGE = 5
	
	accepted_tool_type = ToolData.Tools.Suture
	
	var visible_rect = get_viewport().get_visible_rect()
	
	center_pos = (visible_rect.position + visible_rect.end) / 2.0
	
	var rand_direction = Vector2(randf(), randf()).normalized()
	firstPoint = center_pos + rand_direction * SUTURE_DRAW_RADIUS
	var rotation_amount = rand_range(90, 270)
	rand_direction = rand_direction.rotated(deg2rad(rotation_amount))
	secondPoint = center_pos + rand_direction * SUTURE_DRAW_RADIUS
	
	wound_line.add_point(firstPoint)
	wound_line.add_point(secondPoint)
	_subdivideLine(4, 0, 0, 1)
	
	midpoint = (secondPoint + firstPoint) / 2.0
	maxDistanceFromMidpoint = firstPoint.distance_to(secondPoint) * 0.8
	if Utils.is_main_scene(self):
		var instance = load("res://Tools/Suture/SutureGameInputHandler.tscn").instance()
		instance.connect("input_finished", self, "process_input")
		add_child(instance)

func _subdivideLine(maxDepth: int, depth: int, p1_index: int, p2_index: int):
	if depth > maxDepth:
		return
	
	var p1 = wound_line.points[p1_index]
	var p2 = wound_line.points[p2_index]

	var p3 = (p1 + p2) / 2.0
	wound_line.add_point(p3, p2_index)

	_subdivideLine(maxDepth, depth + 1, p2_index, p2_index + 1)
	_subdivideLine(maxDepth, depth + 1, p1_index, p2_index)


func _draw():
	if Utils.DRAW_DEBUG:
		draw_circle(center_pos, SUTURE_DRAW_RADIUS, Color.green)
		var opaque = Color.green
		draw_circle(midpoint, maxDistanceFromMidpoint, Color(opaque.r, opaque.g, opaque.b, 0.25))

# https://stackoverflow.com/questions/1560492/how-to-tell-whether-a-point-is-to-the-right-or-left-side-of-a-line
func get_side(test_point: Vector2) -> float:
	var a = firstPoint
	var b = secondPoint
	var c = test_point
	return sign((b.x - a.x) * (c.y - a.y) - (b.y - a.y)*(c.x - a.x))

func accept_tool_input(tool_input_data: SutureInputData):
	if tool_input_data.has_intersection:
		print("Suture failed")
		$Fail.play()
		emit_signal("botch_made", BOTCH_DAMAGE)
		return

	var current_side = 0
	
	var side_change_count = 0
	var failed = false
	
	for point in tool_input_data.points:		
		if point.distance_to(midpoint) > maxDistanceFromMidpoint:
			failed = true
			break
		
		var side = get_side(point)
		
		if side != current_side:
			side_change_count += 1
			current_side = side
	
	if !failed and side_change_count > REQUIRED_SIDE_CHANGE_COUNT:
		print("Suture pass")
		$Success.play()
		emit_signal("game_finished", true)
	else:
		print("Suture fail")
		$Fail.play()
		emit_signal("botch_made", BOTCH_DAMAGE)
