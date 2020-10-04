extends Node

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
