extends Node


enum Tools {
	Scalpel,
	Test,
}

# TODO:
const TOOLS_DATA = {
	Tools.Scalpel: {
		"name": "Scalpel",
		"texture": preload("res://DriveInScreen/SelectableTools/scalpel.png"),
		"tool_scene": preload("res://Tools/Scalpel/ScalpelGame.tscn"),
	},
	Tools.Test: {
		"name": "Test",
		"texture": preload("res://icon.png"),
		"tool_scene": preload("res://Tools/Bandage/BandageGame.tscn")
	}
}
