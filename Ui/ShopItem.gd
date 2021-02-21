extends MarginContainer

signal pressed(this)

var tool_type
var purchased = false

func set_data(tool_type):
	self.tool_type = tool_type
	$MarginContainer2/VBoxContainer/TextureRect.texture = ToolData.TOOLS_DATA[tool_type].texture
	$MarginContainer2/VBoxContainer/ItemName.text = ToolData.TOOLS_DATA[tool_type].name
	$MarginContainer2/VBoxContainer/ItemCost.text = "$" + str(ToolData.TOOLS_DATA[tool_type].cost)


func _on_ShopItem_gui_input(event):
	if event is InputEventMouseButton and not purchased:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			emit_signal("pressed", self)

func purchase():
	purchased = true
	modulate = Color.gray

func _on_ShopItem_mouse_entered():
	if !purchased:
		modulate = Color.green

func _on_ShopItem_mouse_exited():
	if !purchased:
		modulate = Color.white
