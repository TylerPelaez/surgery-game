extends Control

const AfflictionTextureRect = preload("res://DriveInScreen/AfflictionDialog/AfflictionTextureRect.tscn")

const AFFLICTION_TEXTURE_PREFIX = "Affliction"


onready var affliction_container = $MarginContainer/VBoxContainer
onready var animation_player = $AnimationPlayer

var _afflictions = []
var show_circle = false

var current_emotion = 0
var emotion_progress = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	if Utils.is_main_scene(self):
		set_afflictions([AfflictionData.Afflictions.HeartPain, AfflictionData.Afflictions.Tumor])

func _draw():
	if show_circle:
		var main_color
		var growing_color
		if current_emotion == 0:
			main_color = Color.green
			growing_color = Color.yellow
		elif current_emotion == 1:
			main_color = Color.yellow
			growing_color = Color.red
		elif current_emotion == 2:
			main_color = Color.red
			growing_color = null	
			
		var draw_position = Vector2($MarginContainer.rect_position.x, 0.0)
		if growing_color != null:
			draw_circle(draw_position, 12.0, main_color)
			
			var starting_angle = 0.0
			var ending_angle = 360.0 * emotion_progress
			draw_arc(draw_position, 12.0, deg2rad(starting_angle - 90), deg2rad(ending_angle - 90), 64, growing_color, 6.0)
		else:
			# now, we need to shrink the arc:
			var starting_angle = 0.0  + (emotion_progress * 360.0)
			var ending_angle = 360.0
			draw_arc(draw_position, 12.0, deg2rad(starting_angle - 90), deg2rad(ending_angle - 90), 64, main_color, 6.0)



func update_circle():
	show_circle = true
	update()
	

func next_emotional_state():
	current_emotion += 1
	emotion_progress = 0.0
	update()

func update_emotion_progress(new_progress):
	emotion_progress = new_progress
	update()

func set_afflictions( afflictions ):
	for affliction in afflictions:
		var new_rect = AfflictionTextureRect.instance()
		new_rect.rect_rotation = 1
		new_rect.mouse_filter = MOUSE_FILTER_IGNORE
		new_rect.texture = AfflictionData.AFFLICTIONS[affliction].texture
		affliction_container.add_child(new_rect)
		new_rect.name = AFFLICTION_TEXTURE_PREFIX + str(affliction)

func set_affliction_prepared(affliction):
	var affliction_texture_rect = affliction_container.get_node(AFFLICTION_TEXTURE_PREFIX + str(affliction))
	affliction_texture_rect.set_addressed()

func _process(delta):
	for child in affliction_container.get_children():
		child.rect_rotation = 1

func show():
	if !visible or animation_player.current_animation == "hide":
		animation_player.play("show")

func hide():
	if visible:
		animation_player.play("hide")
