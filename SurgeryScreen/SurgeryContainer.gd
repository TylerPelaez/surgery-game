extends VBoxContainer

signal all_games_finished(percent_damage_taken)
signal patient_death

const RESTING_HEART_RATE = 95
const MIN_HEART_RATE = 10
const MAX_HEART_RATE = 180
const NATURAL_FLUCTUATION_PER_SECOND = 2.0


const SURGERY_TEXTURES = [
	preload("res://Assets/Organs/Heart.png"), 
	preload("res://Assets/Organs/Liver.png"), 
	preload("res://Assets/Organs/Stomach.png")
]
const MAX_TEXTURE_OFFSET = Vector2(-500, -700)


const SELECT_HOVER_COLOR = Color("#e4e89c")

const ToolSelectButtonScene = preload("res://Ui/SurgeryToolSelectButton.tscn")

var current_heart_rate setget set_heart_rate

onready var viewport = $HBoxContainer/GameScreenContainer/MarginContainer/ViewportContainer/Viewport
onready var bpm_label = $HBoxContainer/GameScreenContainer/BPMLabel
onready var tool_select_container = $ToolSelectContainer

onready var defib_button = $HBoxContainer/DefibItemButton/DefibMarginContainer
onready var adenosine_button = $HBoxContainer/AdenosineItemButton/DefibMarginContainer
onready var original_defib_modulate = $HBoxContainer/DefibItemButton/DefibMarginContainer/NinePatchRect.modulate
onready var original_adenosine_modulate = $HBoxContainer/AdenosineItemButton/DefibMarginContainer/NinePatchRect.modulate

var surgery_list = []
var current_game
var current_input_handler
var direction_multiplier = 1.0
var running = false

var defib_available = false
var adenosine_available = false


var last_viewed_organ = 2
var currently_selected_button

func _physics_process(delta):
	if running:
		self.current_heart_rate += (delta * NATURAL_FLUCTUATION_PER_SECOND * direction_multiplier)
		
		var tool_selected = null
		
		if Input.is_action_just_pressed("1"):
			tool_selected = 0
		elif Input.is_action_just_pressed("2"):
			tool_selected = 1
		elif Input.is_action_just_pressed("3"):
			tool_selected = 2
		elif Input.is_action_just_pressed("4"):
			tool_selected = 3
		elif Input.is_action_just_pressed("5"):
			tool_selected = 4
		
		if tool_selected != null && tool_selected <= tool_select_container.get_child_count() - 1:
			tool_select_container.get_child(tool_selected).select()

func set_heart_rate(value):
	current_heart_rate = value
	if current_heart_rate > MAX_HEART_RATE or current_heart_rate < MIN_HEART_RATE:
		emit_signal("patient_death")
		
		if current_input_handler != null:
			current_input_handler.queue_free()
		for child in tool_select_container.get_children():
			tool_select_container.remove_child(child)
			child.queue_free()
		current_game.queue_free()
		running = false
	
	bpm_label.text = str(round(current_heart_rate))


func add_surgery_games_for_afflictions(afflictions):
	# First the simple stuff:
	# Set up the background:
	if (last_viewed_organ == 2):
		SURGERY_TEXTURES.shuffle()
		last_viewed_organ = -1
	last_viewed_organ += 1
	var viewport_background = viewport.get_node("TextureRect")
	
	viewport_background.texture = SURGERY_TEXTURES[last_viewed_organ]
	viewport_background.rect_position = Vector2(rand_range(0.0, MAX_TEXTURE_OFFSET.x), rand_range(0.0, MAX_TEXTURE_OFFSET.y))
	
	# Now create the list of games
	# No sets in godot :( 
	var unique_tools = {}
	
	for affliction in afflictions:
		for tool_required_data in AfflictionData.AFFLICTIONS[affliction].tools_required:
			var tool_to_add = tool_required_data["tool"]
			
			if !unique_tools.has(tool_to_add):
				unique_tools[tool_to_add] = true
			
			var task_count = 1
			if tool_required_data.has("task_count"):
				task_count = tool_required_data.task_count
			
			for i in range(task_count):
				surgery_list.append(ToolData.TOOLS_DATA[tool_to_add].tool_scene)
	
	var only_tool_button = null
	
	var unique_tool_list = []
	# Get the UI buttons working:
	for tool_to_add in unique_tools:
		unique_tool_list.append(tool_to_add)
	
	unique_tool_list.sort()
	
	for tool_to_add in unique_tool_list:
		var instance = ToolSelectButtonScene.instance()
		tool_select_container.add_child(instance)
		instance.set_tool(tool_to_add)
		instance.connect("selected", self, "_on_tool_select_button_selected")
		if unique_tools.size() == 1:
			only_tool_button = instance
	
	# Reset some state
	self.current_heart_rate = RESTING_HEART_RATE
	if randf() > 0.5:
		direction_multiplier = -1.0
	else:
		direction_multiplier = 1.0
	
	# And begin
	get_next_game()
	running = true
	
	# For user convenience: If there's only one choice to make, let's make it for them
	if only_tool_button != null:
		only_tool_button.select()

func _on_tool_select_button_selected(button, tool_type):
	if current_input_handler != null:
		current_input_handler.queue_free()
	
	if currently_selected_button == defib_button:
		defib_button.get_node("NinePatchRect").modulate = original_defib_modulate
	elif currently_selected_button == adenosine_button:
		adenosine_button.get_node("NinePatchRect").modulate = original_adenosine_modulate
	elif currently_selected_button != null && button != currently_selected_button:
		currently_selected_button.deselect()
	
	currently_selected_button = button
	
	current_input_handler = ToolData.TOOLS_DATA[tool_type].tool_input_handler.instance()
	current_game.add_child(current_input_handler)
	current_input_handler.connect("input_finished", current_game, "process_input")
	current_input_handler.connect("do_botch", current_game, "process_botch")


func _on_game_finished(result):
	if current_game != null:
		current_game.queue_free()
	if !surgery_list.empty():
		get_next_game()
		var tmp = currently_selected_button
		currently_selected_button.deselect()
		currently_selected_button = null
		tmp.select()
	else:
		if current_input_handler != null:
			current_input_handler.queue_free()
		for child in tool_select_container.get_children():
			tool_select_container.remove_child(child)
			child.queue_free()
		
		running = false
		var damage_taken = current_heart_rate - RESTING_HEART_RATE
		var percent_damage_taken = 0.0
		if damage_taken <= 0:
			percent_damage_taken = damage_taken / (MIN_HEART_RATE - RESTING_HEART_RATE)
		else:
			percent_damage_taken = damage_taken / (MAX_HEART_RATE - RESTING_HEART_RATE)
		
		emit_signal("all_games_finished", percent_damage_taken)

func _on_botch_made(damage):
	self.current_heart_rate += (damage * direction_multiplier)

func _on_health_item_used(amount):
	self.current_heart_rate += amount
	
	if current_input_handler != null:
		current_input_handler.queue_free()
		current_input_handler = null
	
	if currently_selected_button == defib_button:
		defib_button.get_node("NinePatchRect").modulate = original_defib_modulate
	elif currently_selected_button == adenosine_button:
		adenosine_button.get_node("NinePatchRect").modulate = original_adenosine_modulate
	

func get_next_game():
	current_game = surgery_list.pop_front().instance()
	current_game.connect("botch_made", self, "_on_botch_made")
	current_game.connect("game_finished", self, "_on_game_finished")
	current_game.connect("health_item_used", self, "_on_health_item_used")
	viewport.add_child(current_game)

func enable_tool(item_tool):
	if item_tool == ToolData.Tools.Defibrillator:
		$HBoxContainer/DefibItemButton.modulate = Color.white
		$HBoxContainer/DefibItemButton/DefibMarginContainer.mouse_filter = MOUSE_FILTER_STOP
		defib_available = true
	else:
		$HBoxContainer/AdenosineItemButton.modulate = Color.white
		$HBoxContainer/AdenosineItemButton/DefibMarginContainer.mouse_filter = MOUSE_FILTER_STOP
		adenosine_available = true

func _on_DefibMarginContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			defib_button.get_node("NinePatchRect").modulate = SELECT_HOVER_COLOR
			_on_tool_select_button_selected(defib_button, ToolData.Tools.Defibrillator)

func _on_DefibMarginContainer_mouse_entered():
	if currently_selected_button != defib_button and defib_available:
		defib_button.get_node("NinePatchRect").modulate = SELECT_HOVER_COLOR

func _on_DefibMarginContainer_mouse_exited():
	if currently_selected_button != defib_button and defib_available:
		defib_button.get_node("NinePatchRect").modulate = original_defib_modulate

func _on_AdenosineMarginContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			adenosine_button.get_node("NinePatchRect").modulate = SELECT_HOVER_COLOR
			_on_tool_select_button_selected(adenosine_button, ToolData.Tools.Adenosine)

func _on_AdenosineMarginContainer_mouse_entered():
	if currently_selected_button != adenosine_button and adenosine_available:
		adenosine_button.get_node("NinePatchRect").modulate = SELECT_HOVER_COLOR

func _on_AdenosineMarginContainer_mouse_exited():
	if currently_selected_button != adenosine_button and adenosine_available:
		adenosine_button.get_node("NinePatchRect").modulate = original_adenosine_modulate
