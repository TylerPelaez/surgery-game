extends Node2D


onready var current_page = $Index

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Close_pressed():
	self.visible = false

func _on_IndexButton_pressed():
	current_page.visible = false
	current_page = $Index
	current_page.visible = true


func _on_HowToPlay_pressed():
	current_page.visible = false
	current_page = $HowToPlay1
	current_page.visible = true


func _on_Procedures_pressed():
	current_page.visible = false
	current_page = $Procedures1
	current_page.visible = true


func _on_Tools_pressed():
	current_page.visible = false
	current_page = $Tools1
	current_page.visible = true


func _on_Next_pressed():
	if current_page == $HowToPlay1:
		current_page.visible = false
		current_page = $HowToPlay2
		current_page.visible = true
	elif current_page == $HowToPlay2:
		current_page.visible = false
		current_page = $HowToPlay3
		current_page.visible = true
	elif current_page == $HowToPlay3:
		pass	
	elif current_page == $Procedures1:
		current_page.visible = false
		current_page = $Procedures2
		current_page.visible = true
	elif current_page == $Procedures2:
		current_page.visible = false
		current_page = $Procedures3
		current_page.visible = true
	elif current_page == $Procedures3:
		pass
	elif current_page == $Tools1:
		current_page.visible = false
		current_page = $Tools2
		current_page.visible = true
	elif current_page == $Tools2:
		current_page.visible = false
		current_page = $Tools3
		current_page.visible = true
	elif current_page == $Tools3:
		current_page.visible = false
		current_page = $Tools4
		current_page.visible = true


func _on_Prev_pressed():
	if current_page == $HowToPlay3:
		current_page.visible = false
		current_page = $HowToPlay2
		current_page.visible = true
	elif current_page == $HowToPlay2:
		current_page.visible = false
		current_page = $HowToPlay1
		current_page.visible = true
	elif current_page == $HowToPlay1:
		pass	
	elif current_page == $Procedures3:
		current_page.visible = false
		current_page = $Procedures2
		current_page.visible = true
	elif current_page == $Procedures2:
		current_page.visible = false
		current_page = $Procedures1
		current_page.visible = true
	elif current_page == $Procedures1:
		pass
	elif current_page == $Tools4:
		current_page.visible = false
		current_page = $Tools3
		current_page.visible = true
	elif current_page == $Tools3:
		current_page.visible = false
		current_page = $Tools2
		current_page.visible = true
	elif current_page == $Tools2:
		current_page.visible = false
		current_page = $Tools1
		current_page.visible = true
