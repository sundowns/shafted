extends CanvasLayer

const enabled_crosshair = preload("res://ui/crosshair.png")
const disabled_crosshair = preload("res://ui/crosshair_disabled.png")

onready var crosshair_texture: TextureRect = $CenterContainer/Crosshair

func _on_fire_enabled():
	crosshair_texture.texture = enabled_crosshair

func _on_fire_disabled():
	crosshair_texture.texture = disabled_crosshair
