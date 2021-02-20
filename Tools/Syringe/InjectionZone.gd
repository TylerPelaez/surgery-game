extends Node2D

onready var color = "none"
onready var syringe_in_zone = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomize Color
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var color_num = rng.randi_range(0,2)
	
	if color_num == 0:
		color = "blue"
		$BlueZone.visible = true
		$YellowZone.visible = false
		$PinkZone.visible = false
	elif color_num == 1:
		color = "yellow"
		$BlueZone.visible = false
		$YellowZone.visible = true
		$PinkZone.visible = false
	elif color_num == 2:
		color = "pink"
		$BlueZone.visible = false
		$YellowZone.visible = false
		$PinkZone.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	syringe_in_zone = true

func _on_Area2D_area_exited(area):
	syringe_in_zone = false
