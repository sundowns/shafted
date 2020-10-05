extends Control

var allow_quit = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	if allow_quit and Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_Timer_timeout():
	allow_quit = true
