extends MarginContainer

signal all_games_finished

const TestScalpelScene = preload("res://Tools/Scalpel/ScalpelGame.tscn")

onready var viewport = $MarginContainer/ViewportContainer/Viewport

var surgery_list = []
var current_game

# Called when the node enters the scene tree for the first time.
func _ready():
	if Utils.is_main_scene(self):
		viewport.add_child(TestScalpelScene.instance())

func add_surgery_games_for_tools(tool_list):
	for tool_to_add in tool_list:
		surgery_list.append(ToolData.TOOLS_DATA[tool_to_add].tool_scene)
	
	get_next_game()
	

func _on_game_finished(result):
	current_game.queue_free()
	if !surgery_list.empty():
		get_next_game()
	else:
		emit_signal("all_games_finished")

func get_next_game():
	current_game = surgery_list.pop_front().instance()
	current_game.connect("game_finished", self, "_on_game_finished")
	viewport.add_child(current_game)
