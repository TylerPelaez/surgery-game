extends Control

const AfflictionTextureRect = preload("res://DriveInScreen/AfflictionDialog/AfflictionTextureRect.tscn")

onready var affliction_container = $MarginContainer/VBoxContainer
onready var animation_player = $AnimationPlayer

var _afflictions = []

# Called when the node enters the scene tree for the first time.
func _ready():
#	if Utils.is_main_scene(self):
	set_afflictions([AfflictionData.Afflictions.HeartPain, AfflictionData.Afflictions.Tumor])

func set_afflictions( afflictions ):
	for affliction in afflictions:
		var new_rect = AfflictionTextureRect.instance()
		new_rect.mouse_filter = MOUSE_FILTER_IGNORE
		new_rect.texture = AfflictionData.AFFLICTIONS[affliction].texture
		affliction_container.add_child(new_rect)

func show():
	if !visible or animation_player.current_animation == "hide":
		animation_player.play("show")

func hide():
	if visible:
		animation_player.play("hide")
