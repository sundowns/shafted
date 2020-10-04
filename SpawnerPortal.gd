extends Spatial
class_name SpawnerPortal

const arrow_scene = preload("res://Arrow.tscn")
const spawn_offset_distance := 1.0

export var target_node_path: NodePath = ""

onready var spawn_location: Spatial = $SpawnLocation
onready var spawn_timer: Timer = $SpawnTimer

var target_position: Vector3 = Vector3.ZERO
var total_arrow_count: int = 1
var spawn_interval: float = 0.3
var total_arrows_spawned: int = 0

func _ready():
	var target = get_node(target_node_path)
	assert(target != null, "SpawnerPortal target is null")
	target_position = target.global_transform.origin

func set_properties(_arrow_count: int, _spawn_interval: float):
	total_arrow_count = _arrow_count
	spawn_interval = _spawn_interval

func start():
	spawn_timer.start(spawn_interval)

func spawn():
	var new_arrow: Arrow = arrow_scene.instance()
	get_tree().current_scene.get_node("./World/Projectiles").add_child(new_arrow)
	
	# move our arrows initial position slightly towards target
	var target_direction = (target_position - global_transform.origin).normalized()
	var spawn_offset = target_direction * spawn_offset_distance
	new_arrow.global_transform.origin = spawn_location.global_transform.origin + spawn_offset
	new_arrow.queue_push(target_position)
#	call_deferred("new_arrow.push_toward")
#	new_arrow.set_orientation(target_position)
#	new_arrow.apply_impulse_towards_position(target_position)

func _on_SpawnTimer_timeout():
	if total_arrows_spawned < total_arrow_count:
		total_arrows_spawned += 1
		spawn()
		spawn_timer.start(spawn_interval)

func _on_DestroyerPortal_destroyed_projectile():
	spawn()
