extends Spatial

signal activated

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var mesh: MeshInstance = $button/Button
onready var highlight_fade_timer: Timer = $HighlightFadeTimer

var is_activated: bool = false

func activate():
	if not is_activated:
		is_activated = true
		emit_signal("activated")
		animation_player.play("Activate")

func on_animation_end():
	is_activated = false
	get_tree().reload_current_scene()

func highlight(highlight_material: Resource):
	mesh.material_override = highlight_material
	highlight_fade_timer.start()

func remove_highlight():
	mesh.material_override = null
