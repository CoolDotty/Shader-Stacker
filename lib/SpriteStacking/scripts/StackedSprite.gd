tool
extends Node2D

export var slice_sheet : Texture = null setget set_slice_sheet  # LIMITATION: All layers must border with transparent pixels
export var columns : int = 1 setget set_columns
export var rows : int = 1 setget set_rows
export var static_z : bool = false setget set_static_z # Don't dynamically calculate Z value
export var height : int = 0 setget set_center; # 0 is on the floor. Adjust values if stack is above/below the floor

var layer_count : int;

const SHADER = preload("res://lib/SpriteStacking/shaders/StackedSprite.shader")

var Mat;
var sheet_size = Vector2(64, 64);
var layer_size = Vector2(64, 64);

func sync_material():
	Mat.set_shader_param("slice_sheet", slice_sheet);
	Mat.set_shader_param("columns", columns);
	Mat.set_shader_param("rows", rows);
	Mat.set_shader_param("layer_count", layer_count);
	Mat.set_shader_param("stretch", SsGlobals.cam_pitch if not Engine.editor_hint else 1);
	Mat.set_shader_param("center", height);

func _ready():
	setup_shader();

func setup_shader():
	layer_count = rows * columns;
	
	if (slice_sheet):
		sheet_size = slice_sheet.get_size();
		layer_size = Vector2(sheet_size.x / columns, sheet_size.y / rows);
	
	Mat = ShaderMaterial.new()
	Mat.shader = SHADER
	self.set_material(Mat)
	call_deferred("sync_material");

func _process(_delta):
	if (not static_z):
		var cam_rot = get_viewport_transform().get_rotation()
		z_index = global_position.rotated(cam_rot).y;
	

func _draw():
	# TODO: draw a polygon that's only the visible parts and dynamic uv mapping
	draw_rect(Rect2(
		-layer_size / 2,
		layer_size
	), Color.black, true);
	
	# Draw a bigger bounding rect to prevent off-screen culling too early
	var largest_possible_size = layer_size + Vector2(layer_count, layer_count) * 2;
	draw_rect(Rect2(
		-largest_possible_size / 2,
		largest_possible_size
	), Color.transparent, false);

# Engine Hints

func on_value_change():
	setup_shader();

func set_slice_sheet(new_value):
	slice_sheet = new_value;
	on_value_change();

func set_columns(new_value):
	columns = new_value;
	on_value_change();

func set_rows(new_value):
	rows = new_value;
	on_value_change();

func set_static_z(new_value):
	static_z = new_value;
	on_value_change();

func set_center(new_value):
	height = new_value;
	on_value_change();
