extends Spatial

const arrow_scene = preload("res://Arrow.tscn")
const spawn_offset_distance := 1.0

export var target_node_path: NodePath = ""

onready var spawn_location: Spatial = $SpawnLocation
onready var spawn_timer: Timer = $SpawnTimer

var target_position: Vector3 = Vector3.ZERO

func _ready():
	var target = get_node(target_node_path)
	assert(target != null, "SpawnerPortal target is null")
	target_position = target.global_transform.origin
	spawn()
	# TODO: How can we make it spawn a few, maybe a timer and a max count?

func spawn():
	var new_arrow: Arrow = arrow_scene.instance()
	get_tree().current_scene.get_node("./Projectiles").add_child(new_arrow)
	# move our arrows initial position slightly towards target
	var target_direction = (target_position - global_transform.origin).normalized()
	var spawn_offset = target_direction * spawn_offset_distance
	new_arrow.global_transform.origin = spawn_location.global_transform.origin + spawn_offset
	new_arrow.look_at(target_position, Vector3.UP)
	new_arrow.apply_impulse_towards_position(target_position)
	
func _on_SpawnTimer_timeout():
	spawn()

func _on_DestroyerPortal_destroyed_projectile():
	spawn()
