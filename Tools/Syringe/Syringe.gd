extends Node2D

signal entered_fill_zone()
signal exited_fill_zone()


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_area_entered(area):
	emit_signal("entered_fill_zone")


func _on_Area2D_area_exited(area):
	emit_signal("exited_fill_zone")
