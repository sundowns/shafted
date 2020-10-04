extends Area

signal destroyed_projectile

func _on_DestroyerPortal_body_entered(body):
	body.queue_free()
	emit_signal("destroyed_projectile")
