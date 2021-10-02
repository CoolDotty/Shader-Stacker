tool
extends Node2D


var _xx = position.x;
var _yy = position.y;
var _scale = 1;
var _heightScale = 1;
var _imageAngle;
var _perspective 

var _alpha = 1;
var HD = false;
var _layerHeight ;
var keshide = false

export var slice_sheet : Texture = null
export var columns : int = 1
export var rows : int = 3

var ci_rid
var sheet_size
var layer_size

#//Need to be calcualted every frame
var _perspectiveTop
var _perspectiveFront 


var spriteOriginX
var spriteOriginY 
var spriteWidth 
var _spriteHeight 
var layer_x_length
var layer_y_length
var _x1
var _y1
var _x2
var _y2
var _x3
var _y3
var _x4
var _y4
var origin
var _corner1Dist
var _corner2Dist
var _corner3Dist
var _corner4Dist
var _corner1Dir
var _corner2Dir
var _corner3Dir
var _corner4Dir

var counter = 0

const SHADER = preload("res://lib/SpriteStacking/shaders/StackedSprite.shader")

func _init():
	set_process(false)
	
func _ready():
	
	_perspective = deg2rad(SsGlobals.cam_pitch)
	
#	Switch on the lines below in case of using VisualServer instead of draw_polyon:
#	ci_rid = VisualServer.canvas_item_create()
	# Make this node the parent.
#	VisualServer.canvas_item_set_parent(ci_rid, get_canvas_item())

	_imageAngle = deg2rad(rotation)
	
	set_process(false)
	
#//Draw the sprites
	if (HD == true) :
		_layerHeight = 0.5;
	else:
		 _layerHeight = 1;
	
	spriteWidth = slice_sheet.get_width() *_scale
	_spriteHeight = slice_sheet.get_height() *_scale;
	layer_x_length =  (float(spriteWidth) / float(columns))
	layer_y_length =  (float(_spriteHeight) / float(rows))
	
	#// Getting the original 4 corners and angles for the corners from the origin
	spriteOriginX = (spriteWidth / 2)
	spriteOriginY = (layer_y_length / 2)
	origin = Vector2 (spriteWidth, layer_y_length)

	_corner1Dist = origin.distance_to (Vector2( spriteOriginX + 0, 0 + spriteOriginY));
	_corner2Dist = origin.distance_to (Vector2(  spriteOriginX + spriteWidth,  0 + spriteOriginY));
	_corner3Dist = origin.distance_to (Vector2( spriteOriginX + spriteWidth,  layer_y_length + spriteOriginY));
	_corner4Dist = origin.distance_to (Vector2(  spriteOriginX + 0,  layer_y_length + spriteOriginY));

	_corner1Dir = origin.angle_to_point(Vector2(  spriteOriginX + 0, 0 + spriteOriginY))     # angle_to_point returns radians
	_corner2Dir = origin.angle_to_point(Vector2(  spriteOriginX + spriteWidth,  0 + spriteOriginY))     # angle_to_point returns radians
	_corner3Dir = origin.angle_to_point(Vector2(  spriteOriginX + spriteWidth,  layer_y_length + spriteOriginY))     # angle_to_point returns radians
	_corner4Dir = origin.angle_to_point(Vector2(  spriteOriginX + 0,  layer_y_length + spriteOriginY))     # angle_to_point returns radians

	set_process(true)

func _process(delta):
	var cam_rot = get_viewport_transform().get_rotation()
	# In case of testing the rotation_degree:
#	rotation += 1                                      
	# In case of testing the camera_pitch:
#	counter += 0.02                                    
#	cam_pitch_deg =  ((sin(counter ) + 1) / 2) * 90      

#	_corner1Dist = origin.distance_to (Vector2( spriteOriginX + 0, 0 + spriteOriginY));
#	_corner2Dist = origin.distance_to (Vector2(  spriteOriginX + spriteWidth,  0 + spriteOriginY));
#	_corner3Dist = origin.distance_to (Vector2( spriteOriginX + spriteWidth,  layer_y_length + spriteOriginY));
#	_corner4Dist = origin.distance_to (Vector2(  spriteOriginX + 0,  layer_y_length + spriteOriginY));
#
#	_corner1Dir = origin.angle_to_point(Vector2(  spriteOriginX + 0, 0 + spriteOriginY))     # angle_to_point returns radians
#	_corner2Dir = origin.angle_to_point(Vector2(  spriteOriginX + spriteWidth,  0 + spriteOriginY))     # angle_to_point returns radians
#	_corner3Dir = origin.angle_to_point(Vector2(  spriteOriginX + spriteWidth,  layer_y_length + spriteOriginY))     # angle_to_point returns radians
#	_corner4Dir = origin.angle_to_point(Vector2(  spriteOriginX + 0,  layer_y_length + spriteOriginY))     # angle_to_point returns radians

	_perspective = deg2rad(SsGlobals.cam_pitch)
	
	var camera_rotation = get_viewport_transform().get_rotation()
	z_index = global_position.rotated(camera_rotation).y
	
#	Switch on the line below in case of using VisualServer instead of draw_polyon:
#	VisualServer.canvas_item_clear(ci_rid);
	update()

#	Switch off the _draw() in case of using VisualServer instead of draw_polyon:
func _draw():
	var camera_rotation = get_canvas_transform().get_rotation()
	var camera_position = get_canvas_transform().get_origin()

	_perspectiveTop = sin(_perspective);
	_perspectiveFront = cos(_perspective);

	#//Get new corner positions using the original 4 corners and angles
	_imageAngle = camera_rotation + rotation
	var points = PoolVector2Array([
		Vector2(
			(Vector2(1,0).rotated(_corner1Dir  + _imageAngle) * _corner1Dist).x ,
			(Vector2(cos( _corner1Dir + _imageAngle),sin( _corner1Dir + _imageAngle)) * _corner1Dist * _perspectiveTop).y
		), Vector2(
			(Vector2(1,0).rotated(_corner2Dir   + _imageAngle) * _corner2Dist).x,
			(Vector2(cos(_corner2Dir + _imageAngle), sin(_corner2Dir + _imageAngle)) * _corner2Dist * _perspectiveTop).y
		), Vector2(
			(Vector2(1,0).rotated(_corner3Dir  + _imageAngle) * _corner3Dist).x,
			(Vector2(cos( _corner3Dir + _imageAngle),sin( _corner3Dir + _imageAngle)) * _corner3Dist * _perspectiveTop).y
		), Vector2(
			(Vector2(1,0).rotated(_corner4Dir  + _imageAngle) * _corner4Dist).x,
			(Vector2(cos(_corner4Dir + _imageAngle),sin(_corner4Dir + _imageAngle)) * _corner4Dist * _perspectiveTop).y
		)
	])
	
	var previous_UV_y
	var next_UV_y
	
	var camera_rotation_inverse = -(camera_rotation + rotation + PI)
	
	var aaa = get_canvas_transform().basis_xform(global_position)
	var resolution_squish = Vector2(0, aaa.y * _perspectiveTop)
	
	draw_rect(Rect2(position - Vector2(5, 5), Vector2(10, 10)), Color.red, true)
	
	for  _i in range (0,  rows, _layerHeight):
		draw_set_transform_matrix(
			Transform2D.IDENTITY.rotated(camera_rotation_inverse).translated(Vector2(0, _i) + resolution_squish)
		)
		
		previous_UV_y = 1 - (float(_i) / float(rows))
		next_UV_y = 1 - (float(_i + 1) / float(rows))
		var UVs = PoolVector2Array([
			Vector2(0, previous_UV_y), 
			Vector2(1, previous_UV_y), 
			Vector2(1, next_UV_y), 
			Vector2(0, next_UV_y)
		])
		
		draw_polygon(points, PoolColorArray(), UVs, slice_sheet)
		
