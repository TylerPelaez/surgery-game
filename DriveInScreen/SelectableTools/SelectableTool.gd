extends Node2D
tool # haha

signal clicked(this)
signal mouse_event(this, entered)
signal released(this)

export (ToolData.Tools) var tool_type setget set_tool_type

onready var sprite = $Sprite

onready var patient_overlap_collider = $PatientOverlap/CollisionShape2D
onready var pickup_area_collider = $PickupArea/CollisionShape2D

var held = false
var selectable = true
var mouse_in = false

var overlapping_patients = []


# Called when the node enters the scene tree for the first time.
func _ready():
	set_tool_type(tool_type)

func init_for_pickup():
	held = true
	selectable = false
	patient_overlap_collider.disabled = false

func set_tool_type(type):
	tool_type = type
	if sprite != null:
		sprite.texture = ToolData.TOOLS_DATA[tool_type].texture
		if ToolData.TOOLS_DATA[tool_type].has("texture_offset"):
			sprite.offset = ToolData.TOOLS_DATA[tool_type].texture_offset
		else:
			sprite.offset = Vector2.ZERO
		sprite.scale = Vector2(1.0, 1.0) * ToolData.TOOLS_DATA[tool_type].texture_scale
	if Engine.is_editor_hint():
		property_list_changed_notify()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if selectable and event.pressed and event.button_index == BUTTON_LEFT:
			emit_signal("clicked", self)
		elif !selectable and held and !event.pressed and event.button_index == BUTTON_LEFT:
			held = false
			emit_signal("released", self)
			queue_free()

# hover logic
func _on_Area2D_mouse_entered():
	if selectable:
		mouse_in = true
		emit_signal("mouse_event", self, true)

func _on_Area2D_mouse_exited():
	if selectable:
		mouse_in = false
		emit_signal("mouse_event", self, false)

func _on_PatientOverlap_area_entered(area):
	overlapping_patients.append(area.get_parent())

func _on_PatientOverlap_area_exited(area):
	overlapping_patients.erase(area.get_parent())

func get_overlapping_patient_for_tool_type(tool_type):
	for patient in overlapping_patients:
		if patient.requires_tool(tool_type):
			return patient
	
	return null
