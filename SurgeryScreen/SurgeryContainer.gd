extends MarginContainer

signal all_games_finished

const RESTING_HEART_RATE = 90
const MIN_HEART_RATE = 20
const MAX_HEART_RATE = 160
const NATURAL_FLUCTUATION_PER_SECOND = 3.0

var current_heart_rate

onready var viewport = $MarginContainer/ViewportContainer/Viewport
onready var bpm_label = $BPMLabel

var surgery_list = []
var current_game
var direction_multiplier = 1.0
var running = false

func _physics_process(delta):
	if running:
		current_heart_rate += (delta * NATURAL_FLUCTUATION_PER_SECOND * direction_multiplier)
		bpm_label.text = str(round(current_heart_rate))

func add_surgery_games_for_tools(tool_list):
	for tool_to_add in tool_list:
		surgery_list.append(ToolData.TOOLS_DATA[tool_to_add].tool_scene)
	
	get_next_game()
	
	running = true
	
	current_heart_rate = RESTING_HEART_RATE
	if randf() > 0.5:
		direction_multiplier = -1.0
	

func _on_game_finished(result):
	current_game.queue_free()
	if !surgery_list.empty():
		get_next_game()
	else:
		running = false
		emit_signal("all_games_finished")

func get_next_game():
	current_game = surgery_list.pop_front().instance()
	current_game.connect("game_finished", self, "_on_game_finished")
	viewport.add_child(current_game)
