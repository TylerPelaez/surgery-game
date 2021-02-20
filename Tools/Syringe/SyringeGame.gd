extends BaseToolMinigame

onready var InjectionNode = preload("res://Tools/Syringe/InjectionZone.tscn");

# Vector2 coordinate array with possible injection zone placements
onready var placement_zones = [Vector2(-409,-246), Vector2(105,-161), Vector2(640,9), Vector2(-168,272), Vector2(500,350)]
# Bool array corresponding to each possible placement zone. True if on, false if off
onready var zone_enabled = [false, false, false, false, false]
# Array of injection nodes
onready var injection_nodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	accepted_tool_type = ToolData.Tools.Syringe
	BOTCH_DAMAGE = 10
	
	# Determine wshich zones are enabled
	for i in range(0, zone_enabled.size()):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var zone_is_enabled = rng.randi_range(0,1)
		if zone_is_enabled == 1:
			zone_enabled[i] = true
	# Spawn an injection zone at each enabled zone
	for i in range(0, zone_enabled.size()):
		if zone_enabled[i] == true:
			var injection_zone = InjectionNode.instance()
			add_child(injection_zone)
			injection_zone.position = placement_zones[i]
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
			touching_injection_zone = true
			if tool_input_data.color == node.color:
				node.visible = false
				injection_nodes.erase(node)
				node.queue_free()
			else:
				print("Syringe minigame botch made!")
				emit_signal("botch_made", BOTCH_DAMAGE)
	if !touching_injection_zone:
		print("Syringe minigame botch made!")
		emit_signal("botch_made", BOTCH_DAMAGE)
	# Check if all nodes have been cleared
	if injection_nodes.size() < 1:
		print("Syringe minigame success!")
		emit_signal("game_finished", true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
