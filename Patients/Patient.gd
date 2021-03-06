extends Node2D

signal not_treated(this)
signal ready_for_surgery(this)

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
							"wait_time_s": 20,
							"payment_curve": preload("res://Patients/PatientNeutralPaymentCurve.tres"),
						},
						{
							"face_texture": preload("res://Patients/BodyParts/facemad.PNG"),
							"wait_time_s": 10,
							"texture_offset": Vector2(0, -12.0),
							"payment_curve": preload("res://Patients/PatientMadPaymentCurve.tres")
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
var tool_in_drop_range = false

var current_emotion = 0
var became_ready_tick_time_ms
var time_to_treatment_ms
var total_possible_wait_time_ms

var afflictions = {}
var prepared_tools = []

var ready_for_surgery = false

# Called when the node enters the scene tree for the first time.
func _ready():
	body.texture = BODY_SPRITES[randi() % BODY_SPRITES.size()]
	head.texture = HEAD_SPRITES[randi() % HEAD_SPRITES.size()]
	hair.texture = HAIR_SPRITES[randi() % HAIR_SPRITES.size()]
	face.texture = EMOTIONAL_STATES[current_emotion].face_texture
	
	var total_wait_time_s = 0
	for state in EMOTIONAL_STATES:
		total_wait_time_s += state.wait_time_s
	
	total_possible_wait_time_ms = total_wait_time_s * 1000.0
	
func init(max_affliction, player_tools):
	var affliction_array = _choose_random_afflictions(1, max_affliction, player_tools)
	for affliction in affliction_array:
		var tools_needed = []
		
		for tool_data in AfflictionData.AFFLICTIONS[affliction].tools_required:
			tools_needed.append(tool_data["tool"])
		
		afflictions[affliction] = tools_needed
	dialog_box.set_afflictions(affliction_array)

func _process(delta):
	if !$EmotionChangeTimer.is_paused() and !$EmotionChangeTimer.is_stopped():
		var current_max_time = EMOTIONAL_STATES[current_emotion].wait_time_s
		dialog_box.update_emotion_progress((current_max_time - $EmotionChangeTimer.time_left) / current_max_time)

func get_all_possible_afflictions_for_tools(player_tools):
	var possible_afflictions = []
	
	for affliction in AfflictionData.Afflictions.values():
		var data = AfflictionData.AFFLICTIONS[affliction]
		var skip = false
		for tool_data in data.tools_required:
			if !player_tools.has(tool_data["tool"]):
				skip = true
				break
		if skip:
			continue
		else:
			possible_afflictions.append(affliction)
	
	return possible_afflictions

func _choose_random_afflictions(min_count, max_count, player_tools):
	var result = []
	var possible_afflictions = get_all_possible_afflictions_for_tools(player_tools)
	
	for i in range(max_count):
		var affliction_to_add = null
		while affliction_to_add == null || result.has(affliction_to_add):
			affliction_to_add = possible_afflictions[randi() % possible_afflictions.size()]
		if i >= min_count:
			if rand_range(0.0, 1.0) > BASE_ADD_AFFLICTION_CHANCE:
				continue
		
		result.append(affliction_to_add)
	
	return result

func _on_spawn_animation_finished():
	ready = true
	$EmotionChangeTimer.start(EMOTIONAL_STATES[current_emotion].wait_time_s)
	became_ready_tick_time_ms = OS.get_ticks_msec()
	$DialogBoxHolder/AfflictionDialogBox.update_circle()

func requires_tool(tool_type):
	if ready_for_surgery:
		return false
	
	for affliction in afflictions.keys():
		if afflictions[affliction].has(tool_type):
			return true
	
	return false	

func prepare_tool(tool_type):
	# O(n^2) lol
	if ready && requires_tool(tool_type):

		for affliction in afflictions.keys():
			if afflictions[affliction].has(tool_type):
				afflictions[affliction].erase(tool_type)
				prepared_tools.append(tool_type)
				if afflictions[affliction].empty():
					dialog_box.set_affliction_prepared(affliction)
				break
		
		var all_empty = true
		for affliction in afflictions.keys():
			if !afflictions[affliction].empty():
				all_empty = false
				break
		
		if all_empty:
			ready_for_surgery = true
			emit_signal("ready_for_surgery", self)

func enter_surgery():
	$EmotionChangeTimer.stop()
	time_to_treatment_ms = OS.get_ticks_msec() - became_ready_tick_time_ms
	prepared_tools.shuffle()

func get_cure_payment():
	var base_payments = []
	for affliction in afflictions.keys():
		base_payments.append(AfflictionData.AFFLICTIONS[affliction].base_payment)
	
	var multiplier = 1.0
	if current_emotion != 0:
		var curve = EMOTIONAL_STATES[current_emotion].payment_curve
		multiplier = curve.interpolate(time_to_treatment_ms / total_possible_wait_time_ms)
	
	var sum = 0
	for base_payment in base_payments:
		sum += base_payment * multiplier 
	
	return sum

func show_dialog_box():
	dialog_box.show()

func check_begin_hide_dialog_box():
	pass

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
		dialog_box.next_emotional_state()
		var emotional_state_dict = EMOTIONAL_STATES[current_emotion]
		face.texture =emotional_state_dict.face_texture
		if emotional_state_dict.has("texture_offset"):
			face.offset += emotional_state_dict.texture_offset
		$EmotionChangeTimer.start(emotional_state_dict.wait_time_s)

func _on_Area2D_area_entered(area):
	tool_in_drop_range = true
	show_dialog_box()


func _on_Area2D_area_exited(area):
	tool_in_drop_range = false
	check_begin_hide_dialog_box()


func _on_InitialHideDialogBoxTimer_timeout():
	check_begin_hide_dialog_box()
