extends Node

var levels: Array = [
	"level6.tscn",
	"level1.tscn",
	"level2.tscn",
	"level3.tscn",
	"level4.tscn",
	"level5.tscn"
]

var current_level_index = 0

func start_game():
	var first_level_name = "res://levels/%s" % levels[current_level_index]
	AudioManager.shafted.play()
	get_tree().change_scene("res://Game.tscn")
	call_deferred("append_level_scene", first_level_name)

func restart_level():
	get_tree().reload_current_scene()
	call_deferred("append_level_scene", "res://levels/%s" % levels[current_level_index])

func load_next_level():
	current_level_index += 1
	if current_level_index >= levels.size():
		all_levels_complete()
		return
	else:
		var root = get_tree().current_scene
		var next_level_name = "res://levels/%s" % levels[current_level_index]
		# Remove the current level
		var level = root.get_node("World")
		root.remove_child(level)
		level.call_deferred("free")
		append_level_scene(next_level_name)

func append_level_scene(level_name: String):
	var root = get_tree().current_scene
	# Add the next level
	var next_level_resource = load(level_name)
	var next_level = next_level_resource.instance()
	root.add_child(next_level, true)

func all_levels_complete():
	get_tree().change_scene("res://ui/ThanksForPlaying.tscn")
