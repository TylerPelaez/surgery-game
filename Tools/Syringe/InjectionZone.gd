extends Node2D

onready var color = "none"
onready var syringe_in_zone = false

const textures = [ preload("res://Assets/Tools/Syringe/Blue Zone.png"), preload("res://Assets/Tools/Syringe/Yellow Zone.png"), preload("res://Assets/Tools/Syringe/Pink Zone.png") ]

func _ready():
	# Randomize Color
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var color_num = rng.randi_range(0,2)
	
	if color_num == 0:
		color = "blue"
	elif color_num == 1:
		color = "yellow"
	elif color_num == 2:
		color = "pink"

	$Sprite.texture = textures[color_num]

func _on_Area2D_area_entered(area):
	syringe_in_zone = true

func _on_Area2D_area_exited(area):
	syringe_in_zone = false
