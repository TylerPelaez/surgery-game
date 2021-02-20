extends Sprite


onready var pipette_in_zone = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	pipette_in_zone = true


func _on_Area2D_area_exited(area):
	pipette_in_zone = false
