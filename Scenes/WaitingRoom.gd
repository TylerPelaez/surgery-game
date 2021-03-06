extends Node2D

const SelectableToolScene = preload("res://DriveInScreen/SelectableTools/SelectableTool.tscn")
const DAY_LENGTH_SECONDS = 180
const TOTAL_NUM_DAYS = 7


onready var patient_generator = $PatientGenerator
onready var surgery_container = $CanvasLayer/SurgeryContainer
onready var grey_out = $CanvasLayer/GreyOut
onready var money_label_container = $CanvasLayer/MoneyLabelContainer
onready var time_label = $CanvasLayer/TimeLabel
onready var day_timer = $DayTimer
onready var day_end_screen = $CanvasLayer/DayEndScreen
onready var shop_container = $CanvasLayer/ShopContainer

# gameplay vars
var currently_held_tool
var patient_in_surgery

# Keep track across Days
var player_money = 0
var current_day = 1
var total_deaths = 0
var total_treated = 0
var total_untreated = 0

var player_tools = []

# Reset Daily
var day_start_money = 0
var death_count = 0
var treated_count = 0
var not_treated_count = 0
var day_ended = false

var state = WAITING_ROOM_DEFAULT


enum  {
	WAITING_ROOM_DEFAULT,
	SURGERY,
	DAY_END_SCREEN,
	SHOP_SCREEN
}


# Called when the node enters the scene tree for the first time.
func _ready():
	patient_generator.connect("spawned_patient", self, "_on_patient_generator_spawned_patient")
	surgery_container.connect("all_games_finished", self, "_on_surgery_container_all_games_finished")
	surgery_container.connect("patient_death", self, "_on_surgery_container_patient_death")
	
	for node in get_tree().get_nodes_in_group("selectable_tool"):
		node.connect("clicked", self, "_on_tool_clicked")
		node.connect("mouse_event", self, "_on_tool_mouse_event")
	
	day_timer.start(DAY_LENGTH_SECONDS)
	time_label.add_color_override("font_color", Color.white)
	
	var shop_items = shop_container.get_all_shop_items()
	var purchaseable_tools = []
	for tool_item in ToolData.Tools.values():
		if ToolData.TOOLS_DATA[tool_item].cost > 0:
			purchaseable_tools.append(tool_item)
		else:
			player_tools.append(tool_item)
		
	purchaseable_tools.sort()
	
	if purchaseable_tools.size() != shop_items.size():
		print("ERROR - size mismatch" + str(purchaseable_tools.size()) + "," + str(shop_items.size()))
		return
	
	for i in range(shop_items.size()):
		var item = shop_items[i]
		item.set_data(purchaseable_tools[i])
		item.connect("pressed", self, "_on_shop_item_pressed")

	for selectable_tool in get_tree().get_nodes_in_group("selectable_tool"):
		if player_tools.has(selectable_tool.tool_type):
			selectable_tool.visible = true
		else:
			selectable_tool.visible = false
	
	patient_generator.start_day(player_tools)

func convert_to_timer_string(time_left):
	var minutes_string = ""
	if time_left >= 60.0:
		minutes_string = str(int(time_left) / 60)
	
	var seconds_string = "%02d" % (int(time_left) % 60)
	
	return minutes_string + ":" + seconds_string

func _physics_process(delta):
	if day_timer.time_left <= 30:
		time_label.add_color_override("font_color", Color.red)
	time_label.text = convert_to_timer_string(day_timer.time_left)
	
	match state:
		WAITING_ROOM_DEFAULT:
			if currently_held_tool != null:
				currently_held_tool.global_position = get_global_mouse_position()
				
			if day_ended and patient_in_surgery == null:
				end_of_day()
		SURGERY:
			return
		DAY_END_SCREEN:
			pass
		SHOP_SCREEN:
			pass
			
func openDrBook():
	$DrBook/DrBook.visible = true
	get_tree().paused = true

func _on_tool_clicked(tool_instance):
	if currently_held_tool != null:
		print_debug("ERROR - currently_held_tool not null")
	else:
		var instance = Utils.instance_scene_on_main(SelectableToolScene, tool_instance.global_position)
		instance.tool_type = tool_instance.tool_type
		instance.init_for_pickup()
		currently_held_tool = instance
		currently_held_tool.connect("released", self, "_on_tool_released")
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_tool_released(tool_instance):
	if currently_held_tool != tool_instance:
		print_debug("ERROR - released tool different from currently held tool")
	else:
		if !currently_held_tool.overlapping_patients.empty():
			var patient = currently_held_tool.get_overlapping_patient_for_tool_type(currently_held_tool.tool_type)
			if patient != null:
				patient.prepare_tool(currently_held_tool.tool_type)
		
		currently_held_tool = null

func _on_tool_mouse_event(tool_instance, entered):
	if entered and currently_held_tool == null:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	elif !entered and currently_held_tool == null:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_patient_generator_spawned_patient(patient):
	patient.connect("ready_for_surgery", self, "_on_patient_ready_for_surgery")
	patient.connect("not_treated", self, "_on_patient_not_treated")

func _on_patient_ready_for_surgery(patient):
	surgery_container.add_surgery_games_for_afflictions(patient.afflictions.keys())
	grey_out.visible = true
	surgery_container.visible = true
	patient_in_surgery = patient
	state = SURGERY
	BackgroundMusic.pause_music()
	patient_in_surgery.enter_surgery()

func _hide_surgery_ui():
	grey_out.visible = false
	surgery_container.visible = false

func _on_surgery_container_all_games_finished(percent_damage_taken):
	state = WAITING_ROOM_DEFAULT
	_hide_surgery_ui()
	patient_generator.remove_patient(patient_in_surgery)
	_on_patient_cured(patient_in_surgery, percent_damage_taken)
	patient_in_surgery.queue_free()
	patient_in_surgery = null
	BackgroundMusic.play_music()

func _on_surgery_container_patient_death():
	state = WAITING_ROOM_DEFAULT
	_hide_surgery_ui()
	patient_generator.remove_patient(patient_in_surgery)
	patient_in_surgery.queue_free()
	patient_in_surgery = null
	_on_patient_death(patient_in_surgery)

func _on_patient_cured(patient, percent_damage_taken):
	treated_count += 1
	total_treated += 1
	var time_waited_payment = patient.get_cure_payment()
	var post_damage_calculation_payment =  max(1.0 - percent_damage_taken, 0.25) * (time_waited_payment)
	money_label_container.set_display_money(player_money)
	player_money += post_damage_calculation_payment
	money_label_container.add_money(post_damage_calculation_payment)

func _on_patient_death(patient):
	death_count += 1
	total_deaths += 1
	get_tree().paused = true
	$CanvasLayer/BotchInfoContainer/AnimationPlayer.play("FadeIn")
	

func _on_patient_not_treated(patient):
	not_treated_count += 1
	total_untreated += 1

func end_of_day():
	if current_day >= 7:
		if player_money >= 2000:
			get_tree().change_scene("res://Win.tscn")
		else:
			get_tree().change_scene("res://Lose.tscn")
	
	state = DAY_END_SCREEN
	grey_out.visible = true
	day_end_screen.set_stats( death_count, treated_count, not_treated_count, player_money - day_start_money, current_day, TOTAL_NUM_DAYS - current_day)
	day_end_screen.visible = true
	patient_generator.end_day()

func _on_shop_item_pressed(item):
	var item_tool = item.tool_type
	# get item cost
	var item_cost = ToolData.TOOLS_DATA[item_tool].cost
	if player_money >= item_cost:
		# can afford:
		item.purchase()
		money_label_container.set_display_money(player_money)
		player_money -= item_cost
		money_label_container.add_money(-item_cost)
		
		player_tools.append(item_tool)
		
		if item_tool == ToolData.Tools.Defibrillator or item_tool == ToolData.Tools.Adenosine:
			surgery_container.enable_tool(item_tool)	
		else:
			for selectable_tool in get_tree().get_nodes_in_group("selectable_tool"):
				if player_tools.has(selectable_tool.tool_type):
					selectable_tool.visible = true
				else:
					selectable_tool.visible = false
		
	
func _on_DayTimer_timeout():
	day_ended = true

func _on_ShopButton_pressed():
	state = SHOP_SCREEN
	shop_container.visible = true

func _on_NextDay_pressed():
	current_day += 1

	grey_out.visible = false
	day_end_screen.visible = false
	patient_generator.start_day(player_tools)
	state = WAITING_ROOM_DEFAULT
	
	day_start_money = player_money
	death_count = 0
	treated_count = 0
	not_treated_count = 0
	day_ended = false
	
	day_timer.start(DAY_LENGTH_SECONDS)
	time_label.add_color_override("font_color", Color.white)
	

func _on_BackButton_pressed():
	state = DAY_END_SCREEN
	shop_container.visible = false

func _on_BotchButton_pressed():
	get_tree().paused = false
	$CanvasLayer/BotchInfoContainer/AnimationPlayer.play("FadeOut")
	BackgroundMusic.play_music()


func _on_DrBookTexture_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			openDrBook()
