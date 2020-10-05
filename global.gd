extends Node

var levels: Array = [
	"test1.tscn",
	"test1.tscn"
]

var current_level_index = 0


func start_game():
	# TODO: call this from menu start button
	var first_level_name = "res://levels/%s" % levels[current_level_index]
	get_tree().change_scene("res://Game.tscn")
	append_level_scene(first_level_name)

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
	print("thanks for playing!!!")
	get_tree().quit()
#	get_tree().change_scene("res://UI/GameComplete.tscn")
