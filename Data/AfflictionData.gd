extends Node

enum Afflictions {
	Fever,
	Cut,
	Vaccination,
	Stitches,
	CoreBiopsy,
	LargeWound,
	Insulin,
	BloodyWound,
	GastricSuction,
	GastricBypass,
	BloodClot,
	SurgicalBiopsy,
	HeartBypass, 
}

const AFFLICTIONS = {
	Afflictions.Fever:
	{
		"name": "Fever",
		"texture": preload("res://Assets/AfflictionIcons/fever.png"),
		"base_payment": 10,
		"tools_required": [
			{
				"tool": ToolData.Tools.RX,
			}
		]
	},
	Afflictions.Cut:
	{
		"name": "Cut",
		"texture": preload("res://Assets/AfflictionIcons/cut.png"),
		"base_payment": 10,
		"tools_required": [
			{
				"tool": ToolData.Tools.Bandage,
			}
		]
	},
	Afflictions.Vaccination:
	{
		"name": "Vaccination",
		"texture": preload("res://Assets/AfflictionIcons/vaccinations.png"),
		"base_payment": 50,
		"tools_required": [
			{
				"tool": ToolData.Tools.Syringe,
			}
		]
	},
	Afflictions.Stitches:
	{
		"name": "Stitches",
		"texture": preload("res://Assets/AfflictionIcons/stitches.png"),
		"base_payment": 20,
		"tools_required": [
			{
				"tool": ToolData.Tools.Suture,
			}
		]
	},
	Afflictions.CoreBiopsy:
	{
		"name": "Core Needle Biopsy",
		"texture": preload("res://Assets/AfflictionIcons/biopsy.png"),
		"base_payment": 20,
		"tools_required": [
			{
				"tool": ToolData.Tools.BiopsyNeedle,
			}
		]
	},
	Afflictions.LargeWound:
	{
		"name": "Large Wound",
		"texture": preload("res://Assets/AfflictionIcons/majorwound.png"),
		"base_payment": 60,
		"tools_required": [
			{
				"tool": ToolData.Tools.Suture,
			},
			{
				"tool": ToolData.Tools.Bandage,
			},
		]
	},
	Afflictions.Insulin:
	{
		"name": "Insulin Injection",
		"texture": preload("res://Assets/AfflictionIcons/insulin.png"),
		"base_payment": 150,
		"tools_required": [
			{
				"tool": ToolData.Tools.Syringe,
			},
			{
				"tool": ToolData.Tools.RX,
			},
		]
	},
	Afflictions.BloodyWound:
	{
		"name": "Bloody Wound",
		"texture": preload("res://Assets/AfflictionIcons/boodywound.png"),
		"base_payment": 200,
		"tools_required": [
			{
				"tool": ToolData.Tools.Pipette,
			},
			{
				"tool": ToolData.Tools.Suture,
			},
			{
				"tool": ToolData.Tools.Bandage,
			},
		]
	},
	Afflictions.GastricSuction:
	{
		"name": "Gastric Suction",
		"texture": preload("res://Assets/AfflictionIcons/gastricsuction.png"),
		"base_payment": 400,
		"tools_required": [
			{
				"tool": ToolData.Tools.Scalpel,
			},
			{
				"tool": ToolData.Tools.Pipette,
			},
			{
				"tool": ToolData.Tools.Suture,
			},
			{
				"tool": ToolData.Tools.Bandage,
			},
		]
	},
	Afflictions.GastricBypass:
	{
		"name": "Gastric Bypass",
		"texture": preload("res://Assets/AfflictionIcons/gastricbypass.png"),
		"base_payment": 400,
		"tools_required": [
			{
				"tool": ToolData.Tools.Scalpel,
				"task_count": 2
			},
			{
				"tool": ToolData.Tools.Suture,
			},
			{
				"tool": ToolData.Tools.Bandage,
			},
		]
	},
	Afflictions.BloodClot:
	{
		"name": "Blood Clot Removal",
		"texture": preload("res://Assets/AfflictionIcons/bloodclot.png"),
		"base_payment": 400,
		"tools_required": [
			{
				"tool": ToolData.Tools.Scalpel,
			},
			{
				"tool": ToolData.Tools.Pipette,
			},
			{
				"tool": ToolData.Tools.Suture,
			},
			{
				"tool": ToolData.Tools.Bandage,
			},
		]
	},
	Afflictions.SurgicalBiopsy:
	{
		"name": "Surgical Biopsy",
		"texture": preload("res://Assets/AfflictionIcons/surgicalbiopsy.png"),
		"base_payment": 400,
		"tools_required": [
			{
				"tool": ToolData.Tools.Scalpel,
			},
			{
				"tool": ToolData.Tools.BiopsyNeedle,
			},
			{
				"tool": ToolData.Tools.Suture,
			},
			{
				"tool": ToolData.Tools.Bandage,
			},
		]
	},
	# order matters!
	Afflictions.HeartBypass:
		{
			"name": "Heart Bypass", 
			"texture": preload("res://Assets/AfflictionIcons/heartbypass.png"),
			"tools_required": [
				{ 
					"tool": ToolData.Tools.Scalpel,
				},
								{ 
					"tool": ToolData.Tools.Syringe,
				},
								{ 
					"tool": ToolData.Tools.Suture,
					"task_count": 2
				},
								{ 
					"tool": ToolData.Tools.Bandage,
				}
			],
			"base_payment": 750,
		}
}

