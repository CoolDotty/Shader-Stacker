tool
extends Node

var cam_pitch = 31.75 setget cam_pitch_set, cam_pitch_get

func cam_pitch_set(new_value):
	cam_pitch = clamp(new_value, 0, 90)

func cam_pitch_get():
	return cam_pitch

func _ready():
	pass
#	get_viewport().render_target_clear_mode = Viewport.CLEAR_MODE_NEVER
	# get_viewport().set_canvas_transform(get_viewport().get_canvas_transform().scaled(Vector2(2, 2)))
