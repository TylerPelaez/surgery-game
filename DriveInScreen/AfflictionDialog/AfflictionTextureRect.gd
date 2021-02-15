extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.seek(rand_range(0, $AnimationPlayer.current_animation_length))

func set_addressed():
	$AnimationPlayer.stop()
	modulate = Color.black
	modulate.a = 0.5
