extends Node2D

const SelectableToolScene = preload("res://DriveInScreen/SelectableTools/SelectableTool.tscn")

var currently_held_tool

# Called when the node enters the scene tree for the first time.
func _ready():
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
		instance.held = true
		instance.selectable = false
		currently_held_tool = instance
		currently_held_tool.connect("released", self, "_on_tool_released")
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_tool_released(tool_instance):
	if currently_held_tool != tool_instance:
		print_debug("ERROR - released tool different from currently held tool")
	else:
		if currently_held_tool.overlapping_patient != null:
			currently_held_tool.overlapping_patient.prepare_tool(currently_held_tool.tool_type)
		
		currently_held_tool = null
		

func _on_tool_mouse_event(tool_instance, entered):
	if entered and currently_held_tool == null:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	elif !entered and currently_held_tool == null:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
