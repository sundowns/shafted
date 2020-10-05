extends Spatial
class_name SpawnerPortal

const arrow_scene = preload("res://Arrow.tscn")
const spawn_offset_distance := 1.0

export var target_node_path: NodePath = ""

onready var spawn_location: Spatial = $SpawnLocation
onready var spawn_timer: Timer = $SpawnTimer
onready var portal_meshes: Spatial = $portal

var target_position: Vector3 = Vector3.ZERO
var total_arrow_count: int = 1
var spawn_interval: float = 0.3
var total_arrows_spawned: int = 0
var is_unlimited: bool = false

func _ready():
	var target = get_node(target_node_path)
	assert(target != null, "SpawnerPortal target is null")
	target_position = target.global_transform.origin
	set_orientation(target_position)

func set_properties(_arrow_count: int, _spawn_interval: float, _is_unlimited: bool):
	total_arrow_count = _arrow_count
	spawn_interval = _spawn_interval
	is_unlimited = _is_unlimited

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

func _on_SpawnTimer_timeout():
	if total_arrows_spawned < total_arrow_count or is_unlimited:
		total_arrows_spawned += 1
		spawn()
		spawn_timer.start(spawn_interval)

func set_orientation(target_position: Vector3):
	var to_target = (target_position - global_transform.origin).normalized()
	# Woke maths gaming
	var dot_product_to_up = to_target.dot(Vector3.UP)
	if abs(dot_product_to_up) == 1:
		portal_meshes.global_rotate(Vector3(1.0, 0, 0), deg2rad(90 * sign(dot_product_to_up)))
	else:
		portal_meshes.look_at(target_position, Vector3.UP)
