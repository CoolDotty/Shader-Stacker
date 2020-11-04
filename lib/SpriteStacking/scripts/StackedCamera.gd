extends Camera2D

var base_zoom : Vector2 = Vector2(1, 1);

func _ready():
	base_zoom = zoom;


func _process(_delta):
	var up_vector = Vector2(cos(rotation - PI/2), sin(rotation - PI/2));
	self.zoom = base_zoom# * up_vector.abs() * SsGlobals.cam_pitch;
