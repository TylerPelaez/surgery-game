extends Control

onready var value_tweener = $ValueTweener
onready var label = $Label
var display_money = 0 setget set_display_money


func _ready():
	if Utils.is_main_scene(self):
		add_money(512)
	
func set_display_money(value):
	display_money = floor(value)
	label.text = "$" + str(display_money)

func add_money(value):
	value_tweener.interpolate_property(self, "display_money", null, display_money + value, 1.0)
	value_tweener.start()
