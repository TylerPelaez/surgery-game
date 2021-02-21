extends Node2D

signal complete()

const PROGRESS_PER_SECOND = 20.0
const MAX_PROGRESS = 100.0

var progress = 0.0
var in_organ = false

func _ready():
	disable_collision()

func add_progress(delta):
	progress += PROGRESS_PER_SECOND * delta
		
	if (progress >= MAX_PROGRESS):
		emit_signal("complete")

func disable_collision():
	$Area2D/CollisionShape2D.disabled = true
	in_organ = false

func enable_collision():
	$Area2D/CollisionShape2D.disabled = false

func is_in_organ():
	return in_organ

func _on_Area2D_area_entered(area):
	in_organ = true


func _on_Area2D_area_exited(area):
	in_organ = false
