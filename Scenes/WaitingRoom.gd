extends Node2D

const SelectableToolScene = preload("res://DriveInScreen/SelectableTools/SelectableTool.tscn")

onready var patient_generator = $PatientGenerator
onready var surgery_container = $CanvasLayer/SurgeryContainer
onready var grey_out = $CanvasLayer/GreyOut

var currently_held_tool
var patient_in_surgery

# Called when the node enters the scene tree for the first time.
func _ready():
	patient_generator.connect("spawned_patient", self, "_on_patient_generator_spawned_patient")
	surgery_container.connect("all_games_finished", self, "_on_surgery_container_all_games_finished")
	
	for node in get_tree().get_nodes_in_group("selectable_tool"):
		node.connect("clicked", self, "_on_tool_clicked")
		node.connect("mouse_event", self, "_on_tool_mouse_event")

func _physics_process(delta):
	if currently_held_tool != null:
		currently_held_tool.global_position = get_global_mouse_position()

func _on_tool_clicked(tool_instance):
	if currently_held_tool != null:
		print_debug("ERROR - currently_held_tool not null")
	else:
		var instance = Utils.instance_scene_on_main(SelectableToolScene, tool_instance.global_position)
		instance.tool_type = tool_instance.tool_type
		instance.init_for_pickup()
		currently_held_tool = instance
		currently_held_tool.connect("released", self, "_on_tool_released")
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_tool_released(tool_instance):
	if currently_held_tool != tool_instance:
		print_debug("ERROR - released tool different from currently held tool")
	else:
		if !currently_held_tool.overlapping_patients.empty():
			var patient = currently_held_tool.get_overlapping_patient_for_tool_type(currently_held_tool.tool_type)
			if patient != null:
				patient.prepare_tool(currently_held_tool.tool_type)
		
		currently_held_tool = null
		

func _on_tool_mouse_event(tool_instance, entered):
	if entered and currently_held_tool == null:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	elif !entered and currently_held_tool == null:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_patient_generator_spawned_patient(patient):
	patient.connect("ready_for_surgery", self, "_on_patient_ready_for_surgery")

func _on_patient_ready_for_surgery(patient):
	surgery_container.add_surgery_games_for_tools(patient.prepared_tools)
	grey_out.visible = true
	surgery_container.visible = true
	patient_in_surgery = patient
	patient_in_surgery.enter_surgery()

func _on_surgery_container_all_games_finished():
	grey_out.visible = false
	surgery_container.visible = false
	patient_in_surgery.cure()
	patient_in_surgery = null
	
