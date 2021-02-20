extends KinematicBody2D


enum State {
	DEFAULT,
	BIOPSY_IN_PROGRESS
}

const MAX_SPEED = 1000
const ACCELERATION = 1000
const FRICTION = 100

onready var timer = $StateChangeTimer


var state = State.DEFAULT
var starting_position
var velocity = Vector2.ZERO

var avoid_target

func _ready():
	 starting_position = position

func _physics_process(delta):
	match state:
		State.DEFAULT:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		State.BIOPSY_IN_PROGRESS:
			if avoid_target == null:
				print("Biopsy State Error: avoid target is null")
				return
			
			avoid_target.add_progress(delta)
			
			var mouse_away_direction = (position - avoid_target.position).normalized()
			var toward_starting_position_direction = (starting_position - position).normalized()
			
			# take the weighted average to get our new target direction
#			var target_direction = (((mouse_away_direction * 60.0) + (toward_starting_position_direction * 40.0)) / 100.0).normalized()
			
			velocity = velocity.move_toward(mouse_away_direction * MAX_SPEED, ACCELERATION * delta)
	
	velocity = move_and_slide(velocity)
	
	
func _transition_to_in_progress():
	timer.start()

func _on_Area2D_area_entered(area):
	if state == State.DEFAULT:
		avoid_target = area.get_parent()
		_transition_to_in_progress()

func _on_Area2D_area_exited(area):
	if state == State.BIOPSY_IN_PROGRESS and avoid_target == area.get_parent():
		avoid_target = null
		state = State.DEFAULT


func _on_BiopsyStateChangeTimer_timeout():
	if state == State.DEFAULT:
		state = State.BIOPSY_IN_PROGRESS
