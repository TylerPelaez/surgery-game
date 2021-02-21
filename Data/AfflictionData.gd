extends Node

enum Afflictions {
	HeartBypass, 
	Tumor,
}

const AFFLICTIONS = {
	
	# order matters!
	Afflictions.HeartBypass:
		{
			"name": "Heart Bypass", 
			"texture": preload("res://Data/Afflictions/heartpain.png"),
			"tools_required": [
				{ 
					"tool": ToolData.Tools.Scalpel,
					# If we ever want some special para`ms for tools like a specific pattern, drug color, etc
					"tool_params": [],
				},
								{ 
					"tool": ToolData.Tools.Syringe,
					# If we ever want some special para`ms for tools like a specific pattern, drug color, etc
					"tool_params": [],
				},
								{ 
					"tool": ToolData.Tools.Suture,
					# If we ever want some special para`ms for tools like a specific pattern, drug color, etc
					"tool_params": [],
					"task_count": 2
				},
								{ 
					"tool": ToolData.Tools.Bandage,
					# If we ever want some special para`ms for tools like a specific pattern, drug color, etc
					"tool_params": [],
				}
			],
			"base_payment": 2000,
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

