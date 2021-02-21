extends Node2D


onready var in_drbook = false


# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color("#2aad75"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("lmb") && in_drbook:
		$DrBook.visible = true


func _on_Area2D_mouse_entered():
	in_drbook = true


func _on_Area2D_mouse_exited():
	in_drbook = false


func _on_Play_pressed():
	pass # Replace with function body.
