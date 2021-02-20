extends Node

enum Afflictions {
	HeartPain, 
	Tumor,
}

const AFFLICTIONS = {
	Afflictions.HeartPain:
		{
			"name": "Heart Pain", 
			"texture": preload("res://Data/Afflictions/heartpain.png"),
			"tools_required": [
				{ 
					"tool": ToolData.Tools.RX,
					# If we ever want some special para`ms for tools like a specific pattern, drug color, etc
					"tool_params": [], 
				},
			],
			"base_payment": 100,
		},
	Afflictions.Tumor:
		{
			"name": "Tumor", 
			"texture": preload("res://Data/Afflictions/tumor.png"),
			"tools_required": [
				{ 
					"tool": ToolData.Tools.Scalpel,
					"tool_params": [], 
				},
				{ 
					"tool": ToolData.Tools.Bandage,
					"tool_params": [], 
				}
			],
			"base_payment": 200,
		}
}

