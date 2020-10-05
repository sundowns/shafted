extends Node

onready var footsteps = $Footsteps
onready var gunshots = $Gunshots
onready var target_break = $TargetBreak
onready var shafted = $Shafted

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

func playGunshot():
	var gunshot_is_playing = false
	for child in gunshots.get_children():
		if child.playing:
			gunshot_is_playing = true
	if !gunshot_is_playing:
		var step = gunshots.get_child(rng.randi_range(0, gunshots.get_child_count() -1))
		step.pitch_scale = rng.randf_range(0.9, 1.1)
		step.play()

func _on_TargetBreak_finished():
	target_break.pitch_scale = rng.randf_range(0.9, 1.1)


func _on_Shafted_finished():
	shafted.play()
