extends Node2D
tool

const PatientScene = preload("res://Patients/Patient.tscn")

export var bounds = 10
export var draw_debug = false




func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if Engine.is_editor_hint():
		update()

func _draw():
	if draw_debug:
		draw_line(Vector2.LEFT * bounds, Vector2.RIGHT * bounds, Color.red, 5)


func spawn_patient():
	var x = global_position.x + rand_range(-bounds, bounds)
	var y = global_position.y
	var instance = Utils.instance_scene_on_main(PatientScene, Vector2(x,y))
	

func _on_SpawnPatientTimer_timeout():
	spawn_patient()
