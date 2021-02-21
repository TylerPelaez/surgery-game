extends MarginContainer

func get_all_shop_items():
	var items = []
	items.append($MarginContainer/VBoxContainer/FirstRowContainer/FirstRow/ShopItem0)
	items.append($MarginContainer/VBoxContainer/FirstRowContainer/FirstRow/ShopItem1)
	items.append($MarginContainer/VBoxContainer/FirstRowContainer/FirstRow/ShopItem2)
	items.append($MarginContainer/VBoxContainer/SecondRowContainer/SecondRow/ShopItem3)
	items.append($MarginContainer/VBoxContainer/SecondRowContainer/SecondRow/ShopItem4)
	items.append($MarginContainer/VBoxContainer/SecondRowContainer/SecondRow/ShopItem5)
	items.append($MarginContainer/VBoxContainer/SecondRowContainer/SecondRow/ShopItem6)

	return items
