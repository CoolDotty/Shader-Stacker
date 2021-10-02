extends Node2D

onready var screen_size = OS.get_window_size()

func _ready():
	update_cam()

func _process(_delta):
	update_cam()
	
	if (Input.is_key_pressed(KEY_W)):
		position += Vector2(0, -1)
	if (Input.is_key_pressed(KEY_S)):
		position += Vector2(0, 1)
	if (Input.is_key_pressed(KEY_A)):
		position += Vector2(-1, 0)
	if (Input.is_key_pressed(KEY_D)):
		position += Vector2(1, 0)
	if (Input.is_key_pressed(KEY_Q)):
		rotation += 0.01
	if (Input.is_key_pressed(KEY_E)):
		rotation -= 0.01
	if (Input.is_key_pressed(KEY_SPACE)):
		SsGlobals.cam_pitch += 1
		print(SsGlobals.cam_pitch)
	if (Input.is_key_pressed(KEY_CONTROL)):
		SsGlobals.cam_pitch -= 1
		print(SsGlobals.cam_pitch)

func update_cam():
	var canvas_transform = Transform2D.IDENTITY # get_viewport().get_canvas_transform()
	canvas_transform = canvas_transform.rotated(rotation)
	canvas_transform[2] = -position + screen_size / 2
#	canvas_transform = canvas_transform.scaled(Vector2(2.8, 2.8))
	get_viewport().set_canvas_transform(canvas_transform)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
