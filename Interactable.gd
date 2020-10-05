extends Area
class_name Interactable

export(NodePath) var parent_path = ".."

onready var parent = get_node(parent_path)

func _ready():
	assert(parent != null, "Interactable has no set parent")
