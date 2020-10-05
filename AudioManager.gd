extends Node

onready var footsteps = $Footsteps
onready var target_break = $TargetBreak

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func stopFootsteps():
	for child in footsteps.get_children():
		if child.playing:
			child.stop()

func playFootstep():
	var footstep_is_playing = false
	for child in footsteps.get_children():
		if child.playing:
			footstep_is_playing = true
	if !footstep_is_playing:
		var step = footsteps.get_child(rng.randi_range(0, footsteps.get_child_count() -1))
		step.pitch_scale = 1.0
		step.volume_db = 0
		step.play()
		
func playCrouchFootstep():
	var footstep_is_playing = false
	for child in footsteps.get_children():
		if child.playing:
			footstep_is_playing = true
	if !footstep_is_playing:
		var step = footsteps.get_child(rng.randi_range(0, footsteps.get_child_count() -1))
		step.pitch_scale = 0.85
		step.volume_db = -10
		step.play()



func _on_TargetBreak_finished():
	target_break.pitch_scale = rng.randf_range(0.9, 1.1)
