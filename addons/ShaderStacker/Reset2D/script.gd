extends Node2D


func _ready():
	var id = get_viewport().get_viewport_rid().get_id()
	add_to_group("zsort{viewportRID}".format({ "viewportRID": id }))


func _process(delta):
	var cam = get_viewport().get_camera_2d()
	var cam_rot = (cam.global_rotation if cam else 1.0)
	var squish = 1 / (cam.zoom.y if cam else 1.0)
	
	self.scale.y = squish
	self.rotation = cam_rot
