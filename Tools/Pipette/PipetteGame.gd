extends BaseToolMinigame


onready var BloodNode = preload("res://Tools/Pipette/Blood.tscn")
# Vector2 coordinate array with possible injection zone placements
onready var placement_zones = [Vector2(219, 194), Vector2(715,218), Vector2(1505,407), Vector2(1775,198), Vector2(420,551), Vector2(912,464), Vector2(1182,581), Vector2(1662,815), Vector2(1003,854), Vector2(648,823)]
# Bool array corresponding to each possible placement zone. True if on, false if off
onready var zone_enabled = [false, false, false, false, false, false, false, false, false, false]
#debugging utility
#onready var zone_enabled = [true, true, true, true, true, true, true, true, true, true]
# Array of blood nodes
onready var blood_nodes = []
# Calculate the blood alpha modulate amount based on delta
onready var modulate_amt = 0.5

var pipette_max = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	accepted_tool_type = ToolData.Tools.Pipette
	BOTCH_DAMAGE = 3

	# Determine wshich zones are enabled
	for i in range(0, zone_enabled.size()):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var zone_is_enabled = rng.randi_range(0,1)
		if zone_is_enabled == 1:
			zone_enabled[i] = true
	
	var scale_factor = Vector2(get_x_scale_factor(), get_y_scale_factor())
	
	var count = 0 
	
	# Spawn an injection zone at each enabled zone
	for i in range(0, zone_enabled.size()):
		if zone_enabled[i] == true:
			var blood = BloodNode.instance()
			add_child(blood)
			
			blood.position = Vector2(placement_zones[i].x * scale_factor.x, placement_zones[i].y * scale_factor.y)
			blood_nodes.append(blood)
			
			count += 1
			if count >= pipette_max:
				break
			
			
	if Utils.is_main_scene(self):
		var instance = load("res://Tools/Pipette/PipetteInputHandler.tscn").instance()
		instance.connect("input_finished", self, "process_input")
		add_child(instance)
		
func accept_tool_input(tool_input_data: PipetteInputData):
	# Iterate through each injection_node to see which one the syringe is in
	var touching_injection_zone = false
	for node in blood_nodes:
		if node.pipette_in_zone:
			$Squish.play()
			touching_injection_zone = true
			# If zone alpha <= 0.3, delete it
			if node.modulate.a <= 0.3:
				node.visible = false
				blood_nodes.erase(node)
				node.queue_free()
				print("Removed some blood!")
			# Reduce alpha value of blood
			else:
				node.modulate.a -= modulate_amt
	if !touching_injection_zone:
		print("Pipette minigame botch made!")
		emit_signal("botch_made", BOTCH_DAMAGE)
	# Check if all nodes have been cleared
	if blood_nodes.size() < 1:
		print("Pipette minigame success!")
		$Success.play()
		emit_signal("game_finished", true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	BOTCH_DAMAGE = 5 * delta
	modulate_amt = 0.5 * delta
