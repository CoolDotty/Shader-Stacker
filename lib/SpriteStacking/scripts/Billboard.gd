tool
extends Sprite

# static_z: Don't dynamically calculate Z value
# Handy if billboard is a child of a parent who does calculate Z
export var static_z : bool = false
# parent_bonded: Maintain Z value relative to parent
# Ex: Leaves child of sprite stacked trunk = true
# Ex: Player in World = false
export var parent_bonded : bool = false

const SHADER = preload("res://lib/SpriteStacking/shaders/Billboard.shader")
var Mat;

var initial_pos;

func sync_material():
	Mat.set_shader_param("stretch", SsGlobals.cam_pitch if not Engine.editor_hint else 1);

func _ready():
	Mat = ShaderMaterial.new()
	Mat.shader = SHADER
	self.set_material(Mat)
	call_deferred("sync_material");
	initial_pos = self.position;

func _process(_delta):
	var cam_rot = get_viewport_transform().get_rotation();
	if not static_z:
		z_index = global_position.rotated(cam_rot).y;
	var up_vector = Vector2(cos(-cam_rot - PI/2), sin(-cam_rot - PI/2));
	if not Engine.editor_hint and parent_bonded:
		self.position = initial_pos.y * -up_vector * SsGlobals.cam_pitch + Vector2(initial_pos.x, 0);
	
