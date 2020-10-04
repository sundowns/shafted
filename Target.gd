extends StaticBody

const fractured_scene = preload("res://meshes/target_fractured.tscn")

signal target_hit

func _on_Hitbox_body_entered(body):
	body.queue_free()
	emit_signal("target_hit")
	replace_with_fractured_mesh()
	queue_free()

func replace_with_fractured_mesh():
	var new_fractured_target = fractured_scene.instance()
	get_tree().current_scene.get_node("World").add_child(new_fractured_target)
	new_fractured_target.global_transform = global_transform
#	global_transform.
#	print(rotation)
	new_fractured_target.rotation = rotation
