extends PathFollow

export(float) var move_speed: float = 5.0

func _physics_process(delta):
	set_offset(offset + move_speed * delta)
