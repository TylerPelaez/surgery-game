extends Node


enum Tools {
	Scalpel,
	Bandage,
	Defibrillator,
	Adenosine,
	Syringe,
	Pipette,
	Suture,
	RX
}

# TODO:
const TOOLS_DATA = {
	Tools.Scalpel: {
		"name": "Scalpel",
		"texture": preload("res://DriveInScreen/SelectableTools/scalpel.png"),
		"texture_scale": 1.0,
		"tool_scene": preload("res://Tools/Scalpel/ScalpelGame.tscn"),
		"tool_input_handler": preload("res://Tools/Scalpel/ScalpelGameInputHandler.tscn")
	},
	Tools.Bandage: {
		"name": "Bandage",
		"texture": preload("res://Assets/Tools/Bandage/Bandages.png"),
		"texture_scale": 0.2,
		"tool_scene": preload("res://Tools/Bandage/BandageGame.tscn"),
		"tool_input_handler": preload("res://Tools/Bandage/BandageGameInputHandler.tscn")
	},
	Tools.Defibrillator: {
		"name": "Defibrillator",
		"texture": preload("res://Assets/Tools/Defibrillator/Defib_View.png"),
		"texture_scale": .15,
		"tool_scene": preload("res://Tools/Defibrillator/DefibrillatorGame.tscn")
	},
	Tools.Adenosine: {
		"name": "Adenosine",
		"texture": preload("res://Assets/Tools/Syringe/Adenosine Vial.png"),
		"texture_scale": .15,
		"tool_scene": preload("res://Tools/Adenosine/AdenosineGame.tscn")
	},
	Tools.Syringe: {
		"name": "Syringe",
		"texture": preload("res://Assets/Tools/Syringe/Blue Vial.png"),
		"texture_scale": .15,
		"tool_scene": preload("res://Tools/Syringe/SyringeGame.tscn"),
		"tool_input_handler": preload("res://Tools/Syringe/SyringeInputHandler.tscn")
	},
	Tools.Pipette: {
		"name": "Pipette",
		"texture": preload("res://Assets/Tools/Pipette/PipetteUITexture.png"),
		"texture_scale": .15,
		"tool_scene": preload("res://Tools/Pipette/PipetteGame.tscn"),
		"tool_input_handler": preload("res://Tools/Pipette/PipetteInputHandler.tscn")
	},
	Tools.Suture: {
		"name": "Suture Needle",
		"texture": preload("res://Assets/Tools/SutureNeedle/sutureneedle.png"),
		"texture_scale": 1.0,
		"tool_scene": preload("res://Tools/Suture/SutureMinigame.tscn"),
		"tool_input_handler": preload("res://Tools/Suture/SutureGameInputHandler.tscn")
	},
	Tools.RX: {
		"name": "RX",
		"texture": preload("res://Assets/Tools/RX/RX Prescription.png"),
		"texture_scale": .15,
		"tool_scene": preload("res://Tools/RX/RXGame.tscn"),
		"tool_input_handler": preload("res://Tools/RX/RXInputHandler.tscn")
	}
}
