extends Node


enum Tools {
	Scalpel,
	Bandage,
	Defibrillator,
}

# TODO:
const TOOLS_DATA = {
	Tools.Scalpel: {
		"name": "Scalpel",
		"texture": preload("res://DriveInScreen/SelectableTools/scalpel.png"),
		"texture_scale": 1.0,
		"tool_scene": preload("res://Tools/Scalpel/ScalpelGame.tscn"),
	},
	Tools.Bandage: {
		"name": "Bandage",
		"texture": preload("res://Assets/Tools/Bandage/Bandages.png"),
		"texture_scale": 0.2,
		"tool_scene": preload("res://Tools/Bandage/BandageGame.tscn"),
	},
	Tools.Defibrillator: {
		"name": "Defibrillator",
		"texture": preload("res://Assets/Tools/Defibrillator/Defib_View.png"),
		"texture_scale": .15,
		"tool_scene": preload("res://Tools/Defibrillator/DefibrillatorGame.tscn")
	}
}
