extends Node2D

signal cured(this)

const HEAD_SPRITES = [ 
						preload("res://Patients/BodyParts/head1.PNG"),
						preload("res://Patients/BodyParts/head2.PNG"),
						preload("res://Patients/BodyParts/head3.PNG"),
						preload("res://Patients/BodyParts/head4.PNG")
					]

const BODY_SPRITES = [ 
						preload("res://Patients/BodyParts/greenbody.PNG"),
						preload("res://Patients/BodyParts/bluebody.PNG"),
						preload("res://Patients/BodyParts/redbody.PNG"),
						preload("res://Patients/BodyParts/purplebody.PNG")
					]
			
const HAIR_SPRITES = [
						preload("res://Patients/BodyParts/hair1.PNG"),
						preload("res://Patients/BodyParts/hair2.PNG"),
						preload("res://Patients/BodyParts/hair3.PNG"),
						preload("res://Patients/BodyParts/hair4.PNG"),
						preload("res://Patients/BodyParts/hair5.PNG"),
						preload("res://Patients/BodyParts/hair6.PNG")
					]
				
const FACE_SPRITES = [
						preload("res://Patients/BodyParts/facehappy.PNG"),
						preload("res://Patients/BodyParts/faceneutral.PNG"),
						preload("res://Patients/BodyParts/facemad.PNG")
					]


onready var body = $ViewportContainer/Viewport/Body
onready var head = $ViewportContainer/Viewport/Body/Head
onready var face = $ViewportContainer/Viewport/Body/Head/Face
onready var hair = $ViewportContainer/Viewport/Body/Head/Hair

var ready = false

# Called when the node enters the scene tree for the first time.
func _ready():
	body.texture = BODY_SPRITES[randi() % BODY_SPRITES.size()]
	head.texture = HEAD_SPRITES[randi() % HEAD_SPRITES.size()]
	hair.texture = HAIR_SPRITES[randi() % HAIR_SPRITES.size()]
	face.texture = FACE_SPRITES[0]
	
	pass # Replace with function body.

func _on_spawn_animation_finished():
	ready = true

func _on_ViewportContainer_gui_input(event):
	if ready and event is InputEventMouseButton:
		emit_signal("cured", self)
		queue_free()
