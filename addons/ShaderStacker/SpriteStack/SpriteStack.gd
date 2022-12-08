@tool
extends Node2D
class_name SpriteStack


@export_category("Sprite Stack")
@export var sprite_sheet: Texture = null
@export var layers: int = 1
@export var z: int = 0
@export_range(0, 360, 0.01, "radians") var yaw: float = 0.0
@export_range(0, 16, 0.1, "suffix:px") var pitch: float = 1.0
@export var static_yaw: bool = false
@export var static_z: bool = false


func _ready():
	var viewport = get_viewport()
	var id = viewport.get_viewport_rid().get_id()
	if (not static_z):
		add_to_group("zsort{viewportRID}".format({ "viewportRID": id }))


func _process(_delta):
	queue_redraw()


func _draw():
	if not sprite_sheet:
		return
	var sheet_size = sprite_sheet.get_size()
	var layer_size = sheet_size / Vector2(1, layers)
	var base_rect = Rect2(Vector2.ZERO, layer_size)
	
	var cam = get_viewport().get_camera_2d()
	var cam_rot = cam.global_rotation if cam and not static_yaw and not Engine.is_editor_hint() else 0.0
	var squish = (cam.zoom.x / cam.zoom.y if cam else 1.0)
	
	var up_vector = Vector2(0, -pitch).rotated(yaw + cam_rot - global_rotation) * squish
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(2, 2)) # Double sized pixels because they look better
	for i in range(1, layers + 1):
		draw_texture_rect_region(
				sprite_sheet,
				Rect2(Vector2.ZERO - (base_rect.size / 2) + i * up_vector - z * up_vector,
						base_rect.size),
				Rect2(Vector2(0, sheet_size.y - i * layer_size.y),
						layer_size))
