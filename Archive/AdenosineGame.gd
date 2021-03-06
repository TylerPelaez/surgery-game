extends BaseToolMinigame

const plunger_starting_pos = Vector2(358, 505)
const plunger_max_y_pos = 280

const syringe_zone_x_pos = 954
const syringe_zone_min_y_pos = 654
const syringe_zone_max_y_pos = 520

const injection_zone_min_x = 82
const injection_zone_max_X = 1834
const injection_zone_min_y = 84
const injection_zone_max_y = 997

const plunger_speed = 200

onready var in_syringe_zone = false
onready var in_injection_zone = false

# True for filling syringe, false for injecting medication
onready var fill_syringe_stage = true

# Called when the node enters the scene tree for the first time.
func _ready():
	BOTCH_DAMAGE = 10
	
	$Syringe/Plunger.position = plunger_starting_pos
	$Syringe.show()
	
	# Randomize position of the syringe success zone
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var syringe_zone_y_pos = rng.randi_range(syringe_zone_min_y_pos, syringe_zone_max_y_pos)
	$SyringeZone.position = Vector2(syringe_zone_x_pos, syringe_zone_y_pos)
	$SyringeZone.show()
	
	# Randomize position of the injection site
	var injection_x = rng.randi_range(injection_zone_min_x, injection_zone_max_X)
	var injection_y = rng.randi_range(injection_zone_min_y, injection_zone_max_y)
	$InjectionZone.position = Vector2(injection_x, injection_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Draw liquid into the syringe while on the fill syringe stage
	if fill_syringe_stage:
		# Reset plunger position if it is at the max position
		if $Syringe/Plunger.position.y < plunger_max_y_pos:
			$Syringe/Plunger.position = plunger_starting_pos
		if Input.is_action_just_pressed("spacebar"):
			$Tink.play()
		if Input.is_action_pressed("spacebar"):
			# Move plunger while spacebar is held
			$Syringe/Plunger.position += Vector2(0 , -plunger_speed * delta)
		if Input.is_action_just_released("spacebar"):
			# Check to see if zone successfully hit, if so, go to next phase of game
			if in_syringe_zone:
				print("Adenosine part 1 passed!")
				fill_syringe_stage = false
				$Syringe.visible = false
				$Vial.visible = false
				$Space.visible = false
				$SyringeZone.visible = false
				$Syringe/Plunger.position.y = plunger_max_y_pos
				$InjectionZone.visible = true
				$Success.play()
			# If not, reset minigame
			else:
				print("Adenosine part 1 failed!")
				$Fail.play()
				$Syringe/Plunger.position = plunger_starting_pos
	# Dispense fluid if mouse held inside injection zone and not on fill syringe stage
	if !fill_syringe_stage:
		if $Syringe/Plunger.position.y > plunger_starting_pos.y:
			$Syringe/Plunger.position.y = plunger_max_y_pos
			$Squish.play()
			if in_injection_zone:
				print("Adenosine minigame passed!")
				$Success.play()
				emit_signal("game_finished", true)
			else:
				print("Adenosine minigame botch!")
				$Fail.play()
				emit_signal("botch_made", BOTCH_DAMAGE)
		if Input.is_action_just_pressed("lmb"):
			$Syringe.visible = true
			$Syringe.position = Vector2(get_global_mouse_position().x - 360, get_global_mouse_position().y - 675)
		if Input.is_action_pressed("lmb"):			
			$Syringe/Plunger.position += Vector2(0, plunger_speed * delta)
		elif Input.is_action_just_released("lmb"):
			$Syringe.visible = false
			$Syringe/Plunger.position.y = plunger_max_y_pos


func _on_Area2D_area_entered(area):
	in_syringe_zone = true


func _on_Area2D_area_exited(area):
	in_syringe_zone = false

func _on_injection_area_entered(area):
	in_injection_zone = true

func _on_injection_area_exited(area):
	in_injection_zone = false
