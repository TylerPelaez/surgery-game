extends GameInputHandler
class_name LineBasedGameInputHandler

const FADE_OUT_ANIMATION = "Fade Out"
const FADE_OUT_NO_DRAW_ANIMATION = "Fade Out No Draw"

onready var line_2d = $Line2D
onready var timer = $Timer
onready var animation_player = $AnimationPlayer

var can_draw = true
var draw_time = 1.0

func _physics_process(delta):
	var mouse_pos = get_mouse_pos()
	if Input.is_action_just_pressed("draw"):
		start_drawing(mouse_pos)
	if Input.is_action_pressed("draw") && can_draw:
		draw(mouse_pos)
	if Input.is_action_just_released("draw"):
		end_drawing(mouse_pos)

func enable_draw():
	can_draw = true

func _on_Timer_timeout():
	times_up()

func times_up():
	timer.stop()
	end_drawing(get_mouse_pos())

func start_drawing(mouse_pos):
	timer.start(draw_time)
	line_2d.modulate = Color.white
	
func draw(mouse_pos):
	pass
	
func end_drawing(mouse_pos):
	pass

func reset():
	line_2d.clear_points()
