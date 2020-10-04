extends StaticBody

signal target_hit

func _on_Hitbox_body_entered(body):
	body.queue_free()
	emit_signal("target_hit")
	queue_free()
