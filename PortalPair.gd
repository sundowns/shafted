extends Spatial

export(int) var arrow_count := 1
export(float) var spawn_interval := 0.2

onready var spawner_portal: SpawnerPortal = $SpawnerPortal 

func _ready():
	spawner_portal.set_properties(arrow_count, spawn_interval)
	spawner_portal.start()
