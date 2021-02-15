extends Node2D
tool

signal spawned_patient(patient)

const PatientScene = preload("res://Patients/Patient.tscn")
const PatientSpawnArea = preload("res://Patients/PatientSpawnArea.tres")

export var max_patients = 6
export var bounds = 10
export var y_bounds = 10
export var draw_debug = false
export var MAX_PATIENT_AFFLICTIONS = 2

var spawned_patients = []


func _ready():
	randomize()
	set_physics_process(true)

func _physics_process(delta):
	if Engine.is_editor_hint():
		update()

func _draw():
	if draw_debug:
		draw_rect(Rect2(Vector2.LEFT.x * bounds, Vector2.UP.y * y_bounds, bounds * 2, y_bounds * 2), Color.red)

func get_spawn_pos_x():
	var test_offset_x = rand_range(-bounds, bounds)
	for try in range(5):
		var test_transform = global_transform.translated(Vector2(test_offset_x, 0))
		if !Utils.shape_cast_would_collide(PatientSpawnArea, test_transform):
			return global_position.x + test_offset_x
		
		test_offset_x += PatientSpawnArea.radius
		if test_offset_x > bounds:
			break
	
	return null

func spawn_patient():
	var x = get_spawn_pos_x()
	if x != null:
		var y = global_position.y + rand_range(-y_bounds, y_bounds)
		var instance = Utils.instance_scene_on_main(PatientScene, Vector2(x,y))
		instance.init(MAX_PATIENT_AFFLICTIONS)
		instance.connect("cured", self, "on_patient_cured_or_not_treated")
		instance.connect("not_treated", self, "on_patient_cured_or_not_treated")
		spawned_patients.append(instance)
		emit_signal("spawned_patient", instance)


func on_patient_cured_or_not_treated(patient):
	spawned_patients.erase(patient)

func _on_SpawnPatientTimer_timeout():
	if spawned_patients.size() < max_patients:
		spawn_patient()
