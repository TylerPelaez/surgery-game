extends Node2D
tool

const names = ["res://Assets/Tools/RX/Amuro Ray.png","res://Assets/Tools/RX/Ash Ketchum.png","res://Assets/Tools/RX/Cho Chang.png","res://Assets/Tools/RX/Elons Kid.png","res://Assets/Tools/RX/Jane Doe.png","res://Assets/Tools/RX/John Doe.png","res://Assets/Tools/RX/Leia Organa.png","res://Assets/Tools/RX/Nao Nagata.png","res://Assets/Tools/RX/Sayla Mass.png","res://Assets/Tools/RX/Spike Spiegel.png"]
const drugs = ["res://Assets/Tools/RX/Blue Pill.png","res://Assets/Tools/RX/Blue Tablet.png","res://Assets/Tools/RX/Pink Pill.png","res://Assets/Tools/RX/Pink Tablet.png","res://Assets/Tools/RX/Red Capsule.png","res://Assets/Tools/RX/Red Pill.png","res://Assets/Tools/RX/Yellow Pill.png","res://Assets/Tools/RX/Yellow Tablet.png"]

onready var topLeft = $topLeft
onready var bottomRight = $bottomRight

func _ready():
	var name_image = load(names[randi() % names.size()])
	var druge_image = load(drugs[randi() % drugs.size()])
	$PatientName.texture = name_image
	$Drug.texture = druge_image
	update()

func position_in_bounds(position_check):
	if (position_check.x > topLeft.global_position.x && 
		position_check.y > topLeft.global_position.y && 
		position_check.x < bottomRight.global_position.x && 
		position_check.y < bottomRight.global_position.y):
		return true
	return false
