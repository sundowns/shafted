extends Control

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		set_pause_state(not get_tree().paused)

func set_pause_state(new_state):
	get_tree().paused = new_state
	visible = new_state
	if new_state == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_resume_button_pressed():
	set_pause_state(false)
