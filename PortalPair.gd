extends Spatial

export(int) var arrow_count := 1
export(float) var spawn_interval := 0.3
export(bool) var is_unlimited := false

onready var spawner_portal: SpawnerPortal = $SpawnerPortal 
onready var destroyer_portal: DestroyerPortal = $DestroyerPortal

signal projectile_was_destroyed

func _ready():
	if not is_unlimited:
		connect("projectile_was_destroyed", spawner_portal, "spawn")
	spawner_portal.set_properties(arrow_count, spawn_interval, is_unlimited)
	spawner_portal.start()


func _on_DestroyerPortal_destroyed_projectile():
	emit_signal("projectile_was_destroyed")
