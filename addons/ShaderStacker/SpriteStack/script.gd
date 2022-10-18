@tool
extends Node2D

@export_category("Sprite Stack")
@export var layers: int = 0
@export var sprite_sheet: Texture2D = null
@export_range(0, 360, 0.01, "radians") var yaw: float = 0.0
@export_range(0, 16, 0.1, "suffix:px") var pitch: float = 1.0


func _ready():
	var viewport = get_viewport()
	var id = viewport.get_viewport_rid().get_id()
	add_to_group("ShaderStacker{viewportRID}".format({ "viewportRID": id }))


func _process(_delta):
	queue_redraw()


func _draw():
	if not sprite_sheet:
		return
	var sheet_size = sprite_sheet.get_size()
	var layer_size = sheet_size / Vector2(1, layers)
	var base_rect = Rect2(Vector2.ZERO, layer_size)
	
	var cam = get_viewport().get_camera_2d()
	var cam_rot = (cam.global_rotation if cam else 1.0)
	var squish = 1 / (cam.zoom.y if cam else 1.0)
	
	var up_vector = Vector2(0, pitch * -1).rotated(yaw + cam_rot) * squish
	for i in range(0, layers + 1):
		draw_texture_rect_region(
				sprite_sheet,
				Rect2(Vector2.ZERO - (base_rect.size / Vector2(2, 2)) + i * up_vector,
						base_rect.size),
				Rect2(Vector2(0, sheet_size.y - i * layer_size.y),
						layer_size))
