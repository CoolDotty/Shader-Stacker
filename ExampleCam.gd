extends Camera2D

var passed = 0;

func _process(delta):
	rotation += PI/8 * delta;
	position = position.rotated(PI/8 * delta);
	passed += delta;
#	SsGlobals.cam_pitch = 0.25 * sin(passed) + 1.3;
