extends StaticBody

# Temporary material to visualise things
const open_material: Resource = preload("res://materials/open_door.tres")

onready var door_collider: CollisionShape = $DoorCollisionShape
onready var mesh_instance: MeshInstance = $MeshInstance

export(int) var count_to_open = 1

var current_count: int = 0
var is_open: bool = false

signal opened

# TODO: create a static frame collider from the blender mesh

func increment_open_counter():
	current_count += 1
	if current_count >= count_to_open:
		open()

func open():
	door_collider.disabled = true
	mesh_instance.material_override = open_material
	emit_signal("opened")
