extends StaticBody

const fractured_scene = preload("res://meshes/target_fractured.tscn")

signal target_hit

func _on_Hitbox_body_entered(body):
	body.hit_target()
	emit_signal("target_hit")
	replace_with_fractured_mesh()
	queue_free()

func replace_with_fractured_mesh():
	var new_fractured_target = fractured_scene.instance()
	get_tree().current_scene.get_node("World").add_child(new_fractured_target)
	new_fractured_target.global_transform = global_transform
	new_fractured_target.rotation = rotation
	new_fractured_target.apply_impact_to_fractures()
