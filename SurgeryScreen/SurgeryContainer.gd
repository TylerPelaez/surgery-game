extends MarginContainer

signal all_games_finished(percent_damage_taken)
signal patient_death

const RESTING_HEART_RATE = 90
const MIN_HEART_RATE = 20
const MAX_HEART_RATE = 160
const NATURAL_FLUCTUATION_PER_SECOND = 3.0

var current_heart_rate setget set_heart_rate

onready var viewport = $MarginContainer/ViewportContainer/Viewport
onready var bpm_label = $BPMLabel

var surgery_list = []
var current_game
var direction_multiplier = 1.0
var running = false

func _physics_process(delta):
	if running:
		self.current_heart_rate += (delta * NATURAL_FLUCTUATION_PER_SECOND * direction_multiplier)


func set_heart_rate(value):
	current_heart_rate = value
	if current_heart_rate > MAX_HEART_RATE or current_heart_rate < MIN_HEART_RATE:
		emit_signal("patient_death")
		current_game.queue_free()
		running = false
	
	bpm_label.text = str(round(current_heart_rate))

func add_surgery_games_for_tools(tool_list):
	surgery_list = []
	for tool_to_add in tool_list:
		surgery_list.append(ToolData.TOOLS_DATA[tool_to_add].tool_scene)
	
	get_next_game()
	
	running = true
	
	self.current_heart_rate = RESTING_HEART_RATE
	if randf() > 0.5:
		direction_multiplier = -1.0
	

func _on_game_finished(result):
	current_game.queue_free()
	if !surgery_list.empty():
		get_next_game()
	else:
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

func get_next_game():
	current_game = surgery_list.pop_front().instance()
	current_game.connect("botch_made", self, "_on_botch_made")
	current_game.connect("game_finished", self, "_on_game_finished")
	viewport.add_child(current_game)

