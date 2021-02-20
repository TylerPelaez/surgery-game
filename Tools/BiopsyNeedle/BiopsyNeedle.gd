extends Node2D

signal complete()

const PROGRESS_PER_SECOND = 20.0
const MAX_PROGRESS = 100.0

var progress = 0.0

func add_progress(delta):
	progress += PROGRESS_PER_SECOND * delta
		
	if (progress >= MAX_PROGRESS):
		emit_signal("complete")
