extends BaseToolMinigame

const POTENTIAL_BIOPSY_POSITION_RADIUS = 100
const OrganScene = preload("res://Tools/BiopsyNeedle/BiopsyOrgan.tscn")

var organ_instance

var bodies_in = [false, false, false, false]


func _ready():
	accepted_tool_type = ToolData.Tools.BiopsyNeedle
	BOTCH_DAMAGE = 5
	
	for child in get_children():
		if child is StaticBody2D or child is Sprite:
			child.position = Vector2(child.position.x * get_x_scale_factor(), child.position.y * get_y_scale_factor())
	
	var viewport_rect = get_viewport().get_visible_rect()
	var center_point = (viewport_rect.end + get_viewport_rect().position) / 2.0
	
	# This is basically polar coordinates
	var theta_direction = Vector2(randf(), randf()).normalized()
	var organ_position = center_point + (theta_direction * POTENTIAL_BIOPSY_POSITION_RADIUS)
	
	organ_instance = OrganScene.instance()
	organ_instance.position = organ_position
	add_child(organ_instance)
	
	if Utils.is_main_scene(self):
		var instance = load("res://Tools/BiopsyNeedle/BiopsyNeedleGameInputHandler.tscn").instance()
		instance.connect("input_finished", self, "process_input")
		add_child(instance)

func _physics_process(delta):
	var do_damage = false
	for val in bodies_in:
		if val:
			do_damage = true
			break
	
	if do_damage:
		emit_signal("botch_made", BOTCH_DAMAGE * delta)


func accept_tool_input(tool_input_data: BiopsyNeedleInputData):
	$Success.play()
	emit_signal("game_finished", true)


# :(
func _on_area1_body_entered(body):
	bodies_in[0] = true

func _on_area2_body_entered(body):
	bodies_in[1] = true

func _on_area3_body_entered(body):
	bodies_in[2] = true

func _on_area4_body_entered(body):
	bodies_in[3] = true

func _on_area1_body_exited(body):
	bodies_in[0] = false

func _on_area2_body_exited(body):
	bodies_in[1] = false

func _on_area3_body_exited(body):
	bodies_in[2] = false

func _on_area4_body_exited(body):
	bodies_in[3] = false
