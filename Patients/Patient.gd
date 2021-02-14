extends Node2D

signal not_treated(this)
signal cured(this)

const HEAD_SPRITES = [ 
						preload("res://Patients/BodyParts/head1.PNG"),
						preload("res://Patients/BodyParts/head2.PNG"),
						preload("res://Patients/BodyParts/head3.PNG"),
						preload("res://Patients/BodyParts/head4.PNG")
					]

const BODY_SPRITES = [ 
						preload("res://Patients/BodyParts/greenbody.PNG"),
						preload("res://Patients/BodyParts/bluebody.PNG"),
						preload("res://Patients/BodyParts/redbody.PNG"),
						preload("res://Patients/BodyParts/purplebody.PNG")
					]
			
const HAIR_SPRITES = [
						preload("res://Patients/BodyParts/hair1.PNG"),
						preload("res://Patients/BodyParts/hair2.PNG"),
						preload("res://Patients/BodyParts/hair3.PNG"),
						preload("res://Patients/BodyParts/hair4.PNG"),
						preload("res://Patients/BodyParts/hair5.PNG"),
						preload("res://Patients/BodyParts/hair6.PNG")
					]
				
const EMOTIONAL_STATES = [
						{ 
							"face_texture": preload("res://Patients/BodyParts/facehappy.PNG"),
							"wait_time_s": 30
						},
						{
							"face_texture": preload("res://Patients/BodyParts/faceneutral.PNG"),
							"wait_time_s": 20
						},
						{
							"face_texture": preload("res://Patients/BodyParts/facemad.PNG"),
							"wait_time_s": 10,
							"texture_offset": Vector2(0, -12.0)
						}
					]

const BASE_ADD_AFFLICTION_CHANCE = 0.5


onready var body = $ViewportContainer/Viewport/Body
onready var head = $ViewportContainer/Viewport/Body/Head
onready var face = $ViewportContainer/Viewport/Body/Head/Face
onready var hair = $ViewportContainer/Viewport/Body/Head/Hair

onready var dialog_box = $DialogBoxHolder/AfflictionDialogBox

var ready = false

var mouse_in_viewport = false
var mouse_in_dialog_box = false

var current_emotion = 0
var became_ready_tick_time_ms

var afflictions

# Called when the node enters the scene tree for the first time.
func _ready():
	body.texture = BODY_SPRITES[randi() % BODY_SPRITES.size()]
	head.texture = HEAD_SPRITES[randi() % HEAD_SPRITES.size()]
	hair.texture = HAIR_SPRITES[randi() % HAIR_SPRITES.size()]
	face.texture = EMOTIONAL_STATES[current_emotion].face_texture

func init(max_affliction):
	afflictions = _choose_random_afflictions(1, max_affliction)
	dialog_box.set_afflictions(afflictions)

func _choose_random_afflictions(min_count, max_count):
	var result = []
	for i in range(max_count):
		var affliction_to_add = null
		while affliction_to_add == null || result.has(affliction_to_add):
			affliction_to_add = AfflictionData.Afflictions.values()[randi() % AfflictionData.Afflictions.size()]
		if i >= min_count:
			if rand_range(0.0, 1.0) > BASE_ADD_AFFLICTION_CHANCE:
				continue
		
		result.append(affliction_to_add)
	
	return result

func _on_spawn_animation_finished():
	ready = true
	$EmotionChangeTimer.start(EMOTIONAL_STATES[current_emotion].wait_time_s)
	became_ready_tick_time_ms = OS.get_ticks_msec()

func _on_ViewportContainer_gui_input(event):
	if ready and event is InputEventMouseButton:
		emit_signal("cured", self)
		queue_free()

func show_dialog_box():
	dialog_box.show()

func check_begin_hide_dialog_box():
	if !mouse_in_viewport and !mouse_in_dialog_box:
		dialog_box.hide()
	

func _on_ViewportContainer_mouse_entered():
	mouse_in_viewport = true
	show_dialog_box()

func _on_AfflictionDialogBox_mouse_entered():
	mouse_in_dialog_box = true
	show_dialog_box()

func _on_ViewportContainer_mouse_exited():
	mouse_in_viewport = false
	check_begin_hide_dialog_box()

func _on_AfflictionDialogBox_mouse_exited():
	mouse_in_dialog_box = false
	check_begin_hide_dialog_box()

func _on_EmotionChangeTimer_timeout():
	current_emotion += 1
	if current_emotion >= EMOTIONAL_STATES.size():
		emit_signal("not_treated", self)
		queue_free()
	else:
		var emotional_state_dict = EMOTIONAL_STATES[current_emotion]
		face.texture =emotional_state_dict.face_texture
		if emotional_state_dict.has("texture_offset"):
			face.offset += emotional_state_dict.texture_offset
		$EmotionChangeTimer.start(emotional_state_dict.wait_time_s)
