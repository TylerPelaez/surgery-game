extends BaseToolMinigame

onready var InjectionNode = preload("res://Tools/Syringe/InjectionZone.tscn");
# Array of injection nodes
onready var injection_nodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	accepted_tool_type = ToolData.Tools.Syringe
	BOTCH_DAMAGE = 10
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var scale_factor = Vector2(get_x_scale_factor(), get_y_scale_factor())
	var at_least_one = false
	
	print(scale_factor)
	# Determine wshich zones are enabled
	for child in get_children():
		if child is Position2D:
			if !at_least_one or rng.randi_range(0,1):
				at_least_one = true
				var injection_zone = InjectionNode.instance()
				add_child(injection_zone)
				injection_zone.position = Vector2(child.position.x * scale_factor.x, child.position.y * scale_factor.y)
				injection_nodes.append(injection_zone)
			

	if Utils.is_main_scene(self):
		var instance = load("res://Tools/Syringe/SyringeInputHandler.tscn").instance()
		instance.connect("input_finished", self, "process_input")
		add_child(instance)
			
func accept_tool_input(tool_input_data: SyringeInputData):
	# Iterate through each injection_node to see which one the syringe is in
	var touching_injection_zone = false
	for node in injection_nodes:
		if node.syringe_in_zone:
			$Squish.play()
			touching_injection_zone = true
			if tool_input_data.color == node.color:
				node.visible = false
				injection_nodes.erase(node)
				node.queue_free()
				$Success.play()
			else:
				print("Syringe minigame botch made!")
				$Fail.play()
				emit_signal("botch_made", BOTCH_DAMAGE)
	if !touching_injection_zone:
		print("Syringe minigame botch made!")
		$Fail.play()
		emit_signal("botch_made", BOTCH_DAMAGE)
	# Check if all nodes have been cleared
	if injection_nodes.size() < 1:
		print("Syringe minigame success!")
		$Success.play()
		emit_signal("game_finished", true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
