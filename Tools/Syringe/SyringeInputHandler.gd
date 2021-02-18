extends GameInputHandler

const syringe_blue_pos = Vector2(0, 0)
const syringe_yellow_pos = Vector2(213, 0)
const syringe_pink_pos = Vector2()

const plunger_starting_pos = Vector2(307.217, 434)
const plunger_max_pos = 243

const syringe_zone_blue_x_pos = 954
const syringe_zone_yellow_x_pos = 576
const syringe_zone_pink_x_pos = 954
const syringe_zone_min_y_pos = 550
const syringe_zone_max_y_pos = 520

const plunger_speed = 200

onready var in_syringe_zone = false

onready var syringe_fill_color = "none"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Syringe.connect("entered_fill_zone", self, "_on_entered_zone")
	$Syringe.connect("exited_fill_zone", self, "_on_exited_zone")
	
	hide_syringe()
	randomize_success_zone()

func randomize_success_zone():
	# Randomize position of the syringe success zone
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var syringe_zone_y_pos = rng.randi_range(syringe_zone_min_y_pos, syringe_zone_max_y_pos)
	$SyringeZone.position = Vector2(syringe_zone_blue_x_pos, syringe_zone_y_pos)
	
func show_syringe(color):
	if color == "blue":
		$Syringe.position = syringe_blue_pos
		$SyringeZone.position.x = syringe_zone_blue_x_pos
	if color == "yellow":
		$Syringe.position = syringe_yellow_pos
		$SyringeZone.position.x = syringe_zone_yellow_x_pos
	if color == "pink":
		$Syringe.position = syringe_pink_pos
		$SyringeZone.position.x = syringe_zone_pink_x_pos
	$Syringe.visible = true
	$SyringeZone.visible = true
	
func hide_syringe():
	$Syringe.visible = false
	$SyringeZone.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Reset plunger position if it is at the max position
		if $Syringe/Plunger.position.y < plunger_max_pos:
			$Syringe/Plunger.position = plunger_starting_pos
		# Spacebar to draw from yellow serum
		if Input.is_action_pressed("spacebar"):
			# Move plunger while spacebar is held
			$Syringe.position = syringe_yellow_pos
			$Syringe/Plunger.position += Vector2(0 , -plunger_speed * delta)
			syringe_fill_color = "none"
			show_syringe("yellow")
		if Input.is_action_just_released("spacebar"):
			# Check to see if zone successfully hit, if so, go to next phase of game
			if in_syringe_zone:
				print("Syringe loaded with yellow fluid!")
				$Syringe/Plunger.position.y = plunger_max_pos
				syringe_fill_color = "yellow"
				# TODO: Feedback for loading success
			# If not, reset minigame
			else:
				print("Syringe loading yellow fluid failed")
				$Syringe/Plunger.position = plunger_starting_pos
				syringe_fill_color = "none"
				# TODO: Feedback for loading failed
				randomize_success_zone()
			hide_syringe()
			
func _on_entered_zone():
	in_syringe_zone = true
	
func _on_exited_zone():
	in_syringe_zone = false
