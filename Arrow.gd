extends RigidBody
class_name Arrow

export(float) var initial_speed := 15.0

onready var mesh: MeshInstance = $MeshInstance
onready var redirect_lockout_timer: Timer = $RedirectLockoutTimer

var can_redirect: bool = true

func _ready():
	set_as_toplevel(true)
	
func apply_impulse_towards_position(position: Vector3):
	var direction = (position - global_transform.origin).normalized()
	apply_central_impulse(direction * initial_speed)

func highlight(highlight_material: Resource):
	mesh.material_override = highlight_material
	
func remove_highlight():
	mesh.material_override = null

func redirect(target_position):
	if not can_redirect:
		return

	look_at(target_position, Vector3.UP)
	# reset velocity before pushing
	linear_velocity = Vector3.ZERO
	apply_impulse_towards_position(target_position)
	can_redirect = false

func _on_RedirectLockoutTimer_timeout():
	can_redirect = true
