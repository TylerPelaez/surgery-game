extends CenterContainer

signal selected(this, tool_type)

onready var tool_texture_rect = $MarginContainer/TextureRectMarginContainer/TextureRect
onready var nine_patch_rect = $MarginContainer/NinePatchRect

const SELECT_HOVER_COLOR = Color("#e4e89c")

var tool_type
var selected = false

func set_tool(_tool_type):
	tool_type = _tool_type
	tool_texture_rect.texture = ToolData.TOOLS_DATA[tool_type].texture

func _on_MarginContainer_mouse_entered():
	if !selected:
		nine_patch_rect.modulate = SELECT_HOVER_COLOR

func _on_MarginContainer_mouse_exited():
	if !selected:
		nine_patch_rect.modulate = Color.white

func _on_MarginContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			select()

func select():
	selected = true
	nine_patch_rect.modulate = SELECT_HOVER_COLOR
	emit_signal("selected", self, tool_type)

func deselect():
	selected = false
	nine_patch_rect.modulate = Color.white
