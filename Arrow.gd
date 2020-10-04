extends RigidBody
class_name Arrow

export(float) var initial_speed := 15.0

onready var mesh = $MeshInstance

func _ready():
	set_as_toplevel(true)
	
func apply_impulse_towards_position(position: Vector3):
	var direction = (position - global_transform.origin).normalized()
	apply_central_impulse(direction * initial_speed)

func highlight(highlight_material: Resource):
	mesh.material_override = highlight_material
	
func remove_highlight():
	mesh.material_override = null
