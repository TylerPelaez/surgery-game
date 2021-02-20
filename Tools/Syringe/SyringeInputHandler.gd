extends GameInputHandler

const SyringeScene = preload("res://Tools/Syringe/Syringe.tscn")
onready var vial_draw = $CanvasLayer/ViewportContainer/Viewport/VialDraw

enum {
	NO_FLUID_DRAWN,
	FLUID_DRAW_IN_PROGRESS,
	FLUID_DRAW_COMPLETE,
	DISPENSING
}

var state = NO_FLUID_DRAWN
var currently_selected_fluid
var dispensing_syringe_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func scale_vector(original):
	return Vector2(original.x * get_x_scale_factor(), original.y * get_y_scale_factor())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		NO_FLUID_DRAWN:
			no_fluid_drawn(delta)
		FLUID_DRAW_IN_PROGRESS:
			fluid_draw_in_progress(delta)
		FLUID_DRAW_COMPLETE:
			fluid_draw_complete(delta)
		DISPENSING:
			dispensing(delta)

func no_fluid_drawn(delta):
	# Waiting for the user to choose a fluid.
	var chosen_fluid = null
	if Input.is_action_just_pressed("q_key"):
		chosen_fluid = Syringe.FluidColor.YELLOW
	if Input.is_action_just_pressed("spacebar"):
		chosen_fluid = Syringe.FluidColor.PINK	
	if Input.is_action_just_pressed("e_key"):
		chosen_fluid = Syringe.FluidColor.BLUE

	if chosen_fluid != null:
		start_fluid_draw_state(chosen_fluid)

func start_fluid_draw_state(fluidColor):
	state = FLUID_DRAW_IN_PROGRESS
	currently_selected_fluid = fluidColor
	vial_draw.start_draw_fluid(fluidColor)
	$Tink.play()
	
func fluid_draw_in_progress(delta):
	if currently_selected_fluid == null:
		print("ERROR - bad state, no selected fluid while drawing")
		return
	
	var released = false
	
	match currently_selected_fluid:
		Syringe.FluidColor.YELLOW:
			if Input.is_action_just_released("q_key"):
				released = true
		Syringe.FluidColor.PINK:
			if Input.is_action_just_released("spacebar"):
				released = true		
		Syringe.FluidColor.BLUE:
			if Input.is_action_just_released("e_key"):
				released = true
	
	if released:
		if vial_draw.syringe_in_zone():
			print("Syringe loaded with " + str(currently_selected_fluid) + " fluid!")
			state = FLUID_DRAW_COMPLETE
			$Success.play()
		else:
			state = NO_FLUID_DRAWN
			currently_selected_fluid = null
			$Fail.play()
		vial_draw.end_fluid_draw()

func fluid_draw_complete(delta):
	if currently_selected_fluid == null:
		print("ERROR - bad state, no selected fluid in draw complete")
		return
		
	var new_chosen_fluid = null
	if Input.is_action_just_pressed("q_key"):
		new_chosen_fluid = Syringe.FluidColor.YELLOW
	if Input.is_action_just_pressed("spacebar"):
		new_chosen_fluid = Syringe.FluidColor.PINK	
	if Input.is_action_just_pressed("e_key"):
		new_chosen_fluid = Syringe.FluidColor.BLUE

	if new_chosen_fluid != null:
		start_fluid_draw_state(new_chosen_fluid)
		return
	
		
	# Begin syringe dispensation 
	if Input.is_action_just_pressed("lmb"):
		var mouse_pos = get_mouse_pos()
		dispensing_syringe_instance = SyringeScene.instance()
		add_child(dispensing_syringe_instance)
		dispensing_syringe_instance.init_for_liquid_dispensing(currently_selected_fluid, mouse_pos)
		dispensing_syringe_instance.connect("liquid_dispensed", self, "_on_DispensingSyringe_liquid_dispensed")
		dispensing_syringe_instance.dispense_liquid()
		dispensing_syringe_instance.scale = Vector2(0.4, 0.4)
		state = DISPENSING

func dispensing(delta):
	if Input.is_action_just_released("lmb"):
		dispensing_syringe_instance.queue_free()
		dispensing_syringe_instance = null
		state = FLUID_DRAW_COMPLETE
	
func _on_VialDraw_liquid_drawn():
	if !state == FLUID_DRAW_IN_PROGRESS:
		print("STATE ERROR current state is " + state + " but liquidDrawn signal was emitted")
	
	state = NO_FLUID_DRAWN
	currently_selected_fluid = null
	vial_draw.call_deferred("end_fluid_draw")

func _on_DispensingSyringe_liquid_dispensed():
	var input_data = SyringeInputData.new()
	input_data.initialize([currently_selected_fluid])
	emit_signal("input_finished", input_data)
	dispensing_syringe_instance.queue_free()
	dispensing_syringe_instance = null
	state = NO_FLUID_DRAWN
	currently_selected_fluid = null
