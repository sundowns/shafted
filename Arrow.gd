extends RigidBody
class_name Arrow

export(float) var initial_speed := 15.0

onready var mesh: MeshInstance = $arrow/Arrow
onready var redirect_lockout_timer: Timer = $RedirectLockoutTimer
onready var highlight_fade_timer: Timer = $HighlightFadeTimer
onready var expiry_timer: Timer = $ExpiryTimer
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var hit_particles: Particles = $HitParticles
onready var head_contact_area: Area = $HeadContactArea

var can_redirect: bool = true

func _ready():
	set_as_toplevel(true)
	animation_player.play("Default")
	
func apply_impulse_towards_position(position: Vector3):
	# reset velocity before pushing
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	var direction = (position - global_transform.origin).normalized()
	apply_central_impulse(direction * initial_speed)

func set_orientation(target_position: Vector3):
	var to_target = (target_position - global_transform.origin).normalized()
	# Woke maths gaming
	var dot_product_to_up = to_target.dot(Vector3.UP)
	if abs(dot_product_to_up) == 1:
		global_rotate(Vector3(1.0, 0, 0), deg2rad(90 * sign(dot_product_to_up)))
	else:
		look_at(target_position, Vector3.UP)

func queue_push(target_position: Vector3):
	call_deferred("push_towards", target_position)
	
func push_towards(target_position: Vector3):
	set_orientation(target_position)
	apply_impulse_towards_position(target_position)
	head_contact_area.get_node("CollisionShape").disabled = false

func highlight(highlight_material: Resource):
	mesh.material_override = highlight_material
	highlight_fade_timer.start()
	
func remove_highlight():
	mesh.material_override = null

func redirect(target_position, from_position):
	if not can_redirect:
		return
	
	global_transform.origin = from_position
	set_orientation(target_position)
	apply_impulse_towards_position(target_position)
	can_redirect = false
	redirect_lockout_timer.start()

func _on_RedirectLockoutTimer_timeout():
	can_redirect = true

func _on_ExpiryTimer_timeout():
	queue_free()

func hit_target(destroy_after: float = 2.0):
	gravity_scale = 1.0
	expiry_timer.stop()
	expiry_timer.start(destroy_after)
	hit_particles.emitting = true

func _on_HeadContactArea_body_entered(body):
	hit_target(5.0)
	animation_player.stop()
