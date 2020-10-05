extends Node

onready var footsteps = $Footsteps
onready var target_break = $TargetBreak

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func playFootstep():
	var footstep_is_playing = false
	for child in footsteps.get_children():
		if child.playing:
			footstep_is_playing = true
	if !footstep_is_playing:
		footsteps.get_child(rng.randi_range(0, footsteps.get_child_count() -1)).play()

