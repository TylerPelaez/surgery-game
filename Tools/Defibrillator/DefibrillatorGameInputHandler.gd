extends GameInputHandler

const offset = Vector2(-200, -280)

onready var in_zone = false
onready var qte_key = "spacebar"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomly pick a prompt that the QTE will use
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var qte_number = rng.randi_range(0, 2)
	
	$SpacePrompt.visible = false
	$QPrompt.visible = false
	$EPrompt.visible = false
	
	# Each string corresponds to an input map in project settings
	# Also, Show the corresponding qte prompt
	if qte_number == 0:
		qte_key = "spacebar"
		$SpacePrompt.visible = true
	elif qte_number == 1:
		qte_key = "q_key"
		$QPrompt.visible = true
	elif qte_number == 2:
		qte_key = "e_key"
		$EPrompt.visible = true
		
	# Randomize the placement of the success zone
	var zone_x_offset = rng.randi_range(784, 1177)
	$Zone.set_position(Vector2(zone_x_offset, 361))
	
	# Randomize the speed of the needle
	var needle_speed = rng.randi_range(500, 750)
	$Path2D/PathFollow2D.needle_speed = needle_speed
	
	$DefibBeep.play()
	
	position += offset
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var success_data = DefibrillatorToolInputData.new()
	success_data.initialize(null)
	
	if Input.is_action_just_pressed("spacebar") && qte_key == "spacebar" && in_zone:
		print("Defibrillator minigame passed!")
		$Success.play()
		emit_signal("input_finished", success_data)
	elif Input.is_action_just_pressed("q_key") && qte_key == "q_key" && in_zone:
		print("Defibrillator minigame passed!")
		$Success.play()
		emit_signal("input_finished", success_data)
	elif Input.is_action_just_pressed("e_key") && qte_key == "e_key" && in_zone:
		print("Defibrillator minigame passed!")
		$Success.play()
		emit_signal("input_finished", success_data)
	elif Input.is_action_just_pressed("spacebar") || Input.is_action_just_pressed("q_key") || Input.is_action_just_pressed("e_key"):
		print("Defibrillator minigame failed!")
		$Fail.play()
		
# When the needle enters the success zone
func _on_Area2D_area_entered(area):
	in_zone = true

# When the needle exits the success zone
func _on_Area2D_area_exited(area):
	in_zone = false
