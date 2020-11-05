tool
extends Node

var cam_pitch = 1;

var default_height;

func _ready():
	default_height = get_viewport().size.y;

func _process(delta):
	if not Engine.editor_hint:
		# TODO: Perspective without the jank Moppin_ method
		get_viewport().size.y = default_height * cam_pitch;
