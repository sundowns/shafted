extends Spatial

const impact_force_magnitude := 20.0

func _on_Timer_timeout():
	queue_free()

func apply_impact_to_fractures():
	# Just apply at the whole targets centre
	var target_centre = global_transform.origin
	for body in get_children():
		if body is RigidBody:
			var direction = body.get_node("Fracture").global_transform.origin - target_centre
			body.apply_central_impulse(direction * impact_force_magnitude)
