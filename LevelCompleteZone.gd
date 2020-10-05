extends Area

var is_activated: bool = false

signal level_complete

func _ready():
	connect("level_complete", Global, "load_next_level")

func _on_LevelCompleteZone_body_entered(_body):
	if not is_activated:
		is_activated = true
		emit_signal("level_complete")
