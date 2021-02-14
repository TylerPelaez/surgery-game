extends Node

enum Afflictions {
	HeartPain, 
	Tumor,
}

const AFFLICTIONS = {
	Afflictions.HeartPain:
		{
			"name": "Heart Pain", 
			"texture": preload("res://Data/Afflictions/heartpain.png")
		},
	Afflictions.Tumor:
		{
			"name": "Tumor", 
			"texture": preload("res://Data/Afflictions/tumor.png")
		}
}

