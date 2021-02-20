extends BaseToolMinigame

# Keep track of rect corner bounds for signature area
const min_corner = Vector2(873,865)
const max_corner = Vector2(1254,970)

# Called when the node enters the scene tree for the first time.
func _ready():
	accepted_tool_type = ToolData.Tools.RX
	BOTCH_DAMAGE = 0
	
	# Randomize name and prescription image to show on RX
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var patient_name = rng.randi_range(0,9)
	var prescription_image = rng.randi_range(0,7)
	
	if patient_name == 0:
		$AmuroRay.visible = true
	if patient_name == 1:
		$AshKetchum.visible = true
	if patient_name == 2:
		$ChoChang.visible = true
	if patient_name == 3:
		$ElonsKid.visible = true
	if patient_name == 4:
		$JaneDoe.visible = true
	if patient_name == 5:
		$JohnDoe.visible = true
	if patient_name == 6:
		$LeiaOrgana.visible = true
	if patient_name == 7:
		$NaoNagata.visible = true
	if patient_name == 8:
		$SaylaMass.visible = true
	if patient_name == 9:
		$SpikeSpiegel.visible = true
		
	if prescription_image == 0:
		$BluePill.visible = true
	if prescription_image == 1:
		$PinkPill.visible = true
	if prescription_image == 2:
		$RedPill.visible = true
	if prescription_image == 3:
		$YellowPill.visible = true
	if prescription_image == 4:
		$BlueTablet.visible = true
	if prescription_image == 5:
		$RedTablet.visible = true
	if prescription_image == 6:
		$PinkTablet.visible = true
	if prescription_image == 7:
		$YellowTablet.visible = true
			
	if Utils.is_main_scene(self):
		var instance = load("res://Tools/RX/RXInputHandler.tscn").instance()
		instance.connect("input_finished", self, "process_input")
		add_child(instance)

# Given an array of Point2D, make sure array is at least size 100, and 75% of the points are in the specified area
func accept_tool_input(tool_input_data: RXInputData):
	var points_in_bounds = 0
	if tool_input_data.points.size() < 100:
		print("RX Game Botch")
		emit_signal("botch_made", BOTCH_DAMAGE)
	else:
		for point in tool_input_data.points:
			if point.x > min_corner.x && point.y > min_corner.y && point.x < max_corner.x && point.y < max_corner.y:
				points_in_bounds += 1
		print("dividing ", points_in_bounds, " by ", tool_input_data.points.size(), " to get ", float(points_in_bounds)/tool_input_data.points.size())
		if float(points_in_bounds)/tool_input_data.points.size() < .75:
			print("RX Game Botch")
			emit_signal("botch_made", BOTCH_DAMAGE)
		else:
			print("RX Game Passed!")
			emit_signal("game_finished", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
