extends GameInputHandler

const syringe_blue_pos = Vector2(0, 0)
const syringe_yellow_pos = Vector2(213, 0)
const syringe_pink_pos = Vector2(425, 0)

const plunger_starting_pos = Vector2(307.217, 434)
const plunger_max_pos = 243

const syringe_zone_blue_x_pos = 363
const syringe_zone_yellow_x_pos = 576
const syringe_zone_pink_x_pos = 788.3
const syringe_zone_min_y_pos = 550
const syringe_zone_max_y_pos = 520

const plunger_speed = 200

onready var in_syringe_zone = false
onready var syringe_fill_color = "none"
onready var syringe_dispensing = false

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
	
	var scale_factor = Vector2(get_x_scale_factor(), get_y_scale_factor())
	
	var syringe_zone_y_pos = rng.randi_range(syringe_zone_min_y_pos, syringe_zone_max_y_pos) * scale_factor.y
	$SyringeZone.position = Vector2(syringe_zone_blue_x_pos * scale_factor.x, syringe_zone_y_pos * scale_factor.y)

func scale_vector(original):
	return Vector2(original.x * get_x_scale_factor(), original.y * get_y_scale_factor())

func show_syringe(color):
	if color == "blue":
		$Syringe.position = syringe_blue_pos 
		$SyringeZone.position.x = syringe_zone_blue_x_pos
		$Syringe/BlueFluid.visible = true
		$Syringe/YellowFluid.visible = false
		$Syringe/PinkFluid.visible = false
	if color == "yellow":
		$Syringe.position = syringe_yellow_pos
		$SyringeZone.position.x = syringe_zone_yellow_x_pos
		$Syringe/BlueFluid.visible = false
		$Syringe/YellowFluid.visible = true
		$Syringe/PinkFluid.visible = false
	if color == "pink":
		$Syringe.position = syringe_pink_pos
		$SyringeZone.position.x = syringe_zone_pink_x_pos
		$Syringe/BlueFluid.visible = false
		$Syringe/YellowFluid.visible = false
		$Syringe/PinkFluid.visible = true
		
	$SyringeZone.position.y *= get_y_scale_factor()
	$Syringe.visible = true
	$SyringeZone.visible = true
	
func hide_syringe():
	$Syringe.visible = false
	$SyringeZone.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Reset plunger position if it is at the max position
	if !syringe_dispensing:
		if $Syringe/Plunger.position.y < plunger_max_pos:
			$Syringe/Plunger.position = plunger_starting_pos
		# Q to draw from Blue serum
		if Input.is_action_just_pressed("q_key"):
			$Syringe/Plunger.position = plunger_starting_pos
		if Input.is_action_pressed("q_key"):
			# Move plunger while spacebar is held
			$Syringe.position = syringe_blue_pos
			$Syringe/Plunger.position += Vector2(0 , -plunger_speed * delta)
			syringe_fill_color = "none"
			show_syringe("blue")
		if Input.is_action_just_released("q_key"):
			# Check to see if zone successfully hit, if so, go to next phase of game
			if in_syringe_zone:
				print("Syringe loaded with blue fluid!")
				$Syringe/Plunger.position.y = plunger_max_pos
				syringe_fill_color = "blue"
				# TODO: Feedback for loading success
			# If not, reset minigame
			else:
				print("Syringe loading blue fluid failed")
				$Syringe/Plunger.position = plunger_starting_pos
				syringe_fill_color = "none"
				# TODO: Feedback for loading failed
				randomize_success_zone()
			hide_syringe()
		# Spacebar to draw from yellow serum
		if Input.is_action_just_pressed("spacebar"):
			$Syringe/Plunger.position = plunger_starting_pos
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
		# E to draw from pink serum
		if Input.is_action_just_pressed("e_key"):
			$Syringe/Plunger.position = plunger_starting_pos
		if Input.is_action_pressed("e_key"):
			# Move plunger while spacebar is held
			$Syringe.position = syringe_pink_pos
			$Syringe/Plunger.position += Vector2(0 , -plunger_speed * delta)
			syringe_fill_color = "none"
			show_syringe("pink")
		if Input.is_action_just_released("e_key"):
			# Check to see if zone successfully hit, if so, go to next phase of game
			if in_syringe_zone:
				print("Syringe loaded with pink fluid!")
				$Syringe/Plunger.position.y = plunger_max_pos
				syringe_fill_color = "pink"
				# TODO: Feedback for loading success
			# If not, reset minigame
			else:
				print("Syringe loading pink fluid failed")
				$Syringe/Plunger.position = plunger_starting_pos
				syringe_fill_color = "none"
				# TODO: Feedback for loading failed
				randomize_success_zone()
			hide_syringe()
	# Check if syringe is done dispensing and send input_finished signal if so
	if $Syringe/Plunger.position.y > plunger_starting_pos.y && syringe_dispensing:
			$Syringe.visible = false
			var input_data = SyringeInputData.new()
			input_data.initialize([syringe_fill_color])
			emit_signal("input_finished", input_data)
			$Syringe/Plunger.position.y = plunger_max_pos
			syringe_fill_color = "none"
			syringe_dispensing = false
	# Begin syringe dispensation 
	if Input.is_action_just_pressed("lmb") && syringe_fill_color != "none":
		$Syringe/Plunger.position.y = plunger_max_pos
		syringe_dispensing = true
		var mouse_pos = get_mouse_pos()
		# Correctly place syringe sprite to correspond with mouse position
		$Syringe.position = Vector2(mouse_pos.x - 360, mouse_pos.y - 665)
		# Correctly position plunger
		show_syringe("syringe_fill_color")
		$SyringeZone.visible = false
	# Play plunger animation
	elif Input.is_action_pressed("lmb") && syringe_fill_color != "none":
		$Syringe/Plunger.position += Vector2(0 , plunger_speed * delta)
	# Botch if syringe dispensation prematurely ended 
	elif Input.is_action_just_released("lmb") && syringe_dispensing:
		syringe_dispensing = false
		hide_syringe()
			
func _on_entered_zone():
	in_syringe_zone = true
	
func _on_exited_zone():
	in_syringe_zone = false
