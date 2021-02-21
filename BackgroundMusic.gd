extends AudioStreamPlayer

# https://opengameart.org/content/shopping-theme
# https://opengameart.org/content/shop-theme

const music = [
	preload("res://Assets/Audio/Buy Something!.ogg"), 
	preload("res://Assets/Audio/Shopping w Paranoid.wav")
]
var current_song = 0

func _ready():
	stream = music[current_song]
	playing = true
	stream_paused = false

func pause_music():
	$AnimationPlayer.play("FadeOut")
	
func play_music():
	$AnimationPlayer.play("FadeIn")

func _on_BackgroundMusic_finished():
	current_song += 1
	if current_song >= music.size():
		current_song = 0
	stream = music[current_song]
	playing = true
	$AnimationPlayer.play("FadeIn")
