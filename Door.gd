extends StaticBody

# Temporary material to visualise things
const open_material: Resource = preload("res://materials/open_door.tres")

onready var door_collider: CollisionShape = $DoorCollisionShape
onready var door_mesh: MeshInstance = $door/Door
onready var animation_player: AnimationPlayer = $AnimationPlayer

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
	animation_player.play("Open")
	$DoorOpenAudio.play()

func on_open_animation_end():
	door_mesh.visible = false
	door_collider.disabled = true
	emit_signal("opened")

func _on_Target_target_hit():
	increment_open_counter()
