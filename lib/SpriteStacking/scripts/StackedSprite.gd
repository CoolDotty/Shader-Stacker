tool
extends Node2D

export var slice_sheet : Texture = null
export var columns : int = 1
export var rows : int = 1
export var static_z : bool = false # Don't dynamically calculate Z value
export var height : int = 0 # 0 is on the floor. Adjust values if stack is above/below the floor

var ci_rid

func _ready():
	# Create a canvas item, child of this node.
	ci_rid = VisualServer.canvas_item_create()
	# Make this node the parent.
	VisualServer.canvas_item_set_parent(ci_rid, get_canvas_item())

func _process(_delta):
	var sheet_size = slice_sheet.get_size()
	var layer_size = sheet_size / Vector2(columns, rows)
	var cam_rot = get_viewport_transform().get_rotation()
	
	# Draw things on the top of the screen first
	z_index = global_position.rotated(cam_rot).y;

	# Keep stacks going towards the top of the screen
	var cam_up = Vector2(sin(cam_rot + rotation), cos(cam_rot + rotation)) * -1

	# TODO: Does clearing every process create overhead?
	VisualServer.canvas_item_clear(ci_rid);

	var base_rect = Rect2(
		Vector2.ZERO,
		layer_size
	)
	base_rect.position = -base_rect.size / 2
	
	var height_unit = cam_up * (SsGlobals.cam_pitch if not Engine.editor_hint else 1)
	var height_offset = height * height_unit
	base_rect.position += height_offset
	for i in range(0, columns * rows + 1):
		base_rect.position += height_unit
		VisualServer.canvas_item_add_texture_rect_region(
			ci_rid,
			base_rect,
			slice_sheet.get_rid(),
			Rect2(Vector2(0, sheet_size.y - i * layer_size.y), layer_size)
		)
