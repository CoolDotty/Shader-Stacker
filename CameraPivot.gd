extends Spatial

func _process(delta):
	if Input.is_key_pressed(KEY_LEFT):
		rotation.y -= 0.01
	if Input.is_key_pressed(KEY_RIGHT):
		rotation.y += 0.01
	if Input.is_key_pressed(KEY_UP):
		rotation.x -= 0.01
	if Input.is_key_pressed(KEY_DOWN):
		rotation.x += 0.01
