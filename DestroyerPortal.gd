extends Area
class_name DestroyerPortal

onready var portal_meshes: Spatial = $portal

signal destroyed_projectile

func _on_DestroyerPortal_body_entered(body):
	body.queue_free()
	emit_signal("destroyed_projectile")

func set_orientation(target_position: Vector3):
	var to_target = (target_position - global_transform.origin).normalized()
	# Woke maths gaming
	var dot_product_to_up = to_target.dot(Vector3.UP)
	if abs(dot_product_to_up) == 1:
		portal_meshes.global_rotate(Vector3(1.0, 0, 0), deg2rad(90 * sign(dot_product_to_up)))
	else:
		portal_meshes.look_at(target_position, Vector3.UP)
