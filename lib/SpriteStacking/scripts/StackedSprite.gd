tool
extends Node2D


var _xx = position.x;
var _yy = position.y;
var _scale = 1;
var _heightScale = 1;
var rot_deg = 70;
var _imageAngle;
export(float, 0, 90, 0.5) var cam_pitch_deg = 45 
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
	
func _init():
	set_process(false)
	
func _ready():
	_perspective = deg2rad(cam_pitch_deg)
	
#	Switch on the lines below in case of using VisualServer instead of draw_polyon:
#	ci_rid = VisualServer.canvas_item_create()
	# Make this node the parent.
#	VisualServer.canvas_item_set_parent(ci_rid, get_canvas_item())

	_imageAngle = deg2rad(rot_deg - 45)
	
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
	
	# In case of testing the rotation_degree:
#	rot_deg += 1                                      
	# In case of testing the camera_pitch:
#	counter += 0.02                                    
#	cam_pitch_deg =  ((sin(counter ) + 1) / 2) * 90      

	_perspective = deg2rad(cam_pitch_deg)
	_imageAngle = deg2rad(rot_deg - 45)
	
#	Switch on the line below in case of using VisualServer instead of draw_polyon:
#	VisualServer.canvas_item_clear(ci_rid);
	update()

#	Switch off the _draw() in case of using VisualServer instead of draw_polyon:
func _draw():

	_perspectiveTop = sin(_perspective);
	_perspectiveFront = cos(_perspective);

	#//Get new corner positions using the original 4 corners and angles

	_x1 = (Vector2(1,0).rotated(_corner1Dir  + _imageAngle) * _corner1Dist).x     
	_y1 = (Vector2(cos( _corner1Dir + _imageAngle),sin( _corner1Dir + _imageAngle)) * _corner1Dist * _perspectiveTop).y 
	_x2 = (Vector2(1,0).rotated(_corner2Dir   + _imageAngle) * _corner2Dist).x  
	_y2 = (Vector2(cos(_corner2Dir + _imageAngle),sin(_corner2Dir + _imageAngle)) * _corner2Dist * _perspectiveTop).y  
	_x3 = (Vector2(1,0).rotated(_corner3Dir  + _imageAngle) * _corner3Dist).x     
	_y3 = (Vector2(cos( _corner3Dir + _imageAngle),sin( _corner3Dir + _imageAngle)) * _corner3Dist * _perspectiveTop).y  
	_x4 = (Vector2(1,0).rotated(_corner4Dir  + _imageAngle) * _corner4Dist).x    
	_y4 = (Vector2(cos(_corner4Dir + _imageAngle),sin(_corner4Dir + _imageAngle)) * _corner4Dist * _perspectiveTop).y   

	var points = PoolVector2Array()
	points = [Vector2(_x1,_y1), Vector2(_x2,_y2), Vector2(_x3,_y3),Vector2(_x4,_y4)]
#	var colour = PoolColorArray()
#	colour = [Color(0,0,1, 1)]
	var UVs = PoolVector2Array()
	
	var previous_UV_y
	var next_UV_y
	
	for  _i in range (0,  rows, _layerHeight):
		points[0].y -= _heightScale * _perspectiveFront 
		points[1].y -= _heightScale * _perspectiveFront 
		points[2].y -= _heightScale * _perspectiveFront 
		points[3].y -= _heightScale * _perspectiveFront 
		
		previous_UV_y = 1 - (float(_i)  / float(rows))
		next_UV_y = 1 - (float(_i + 1) / float(rows))
		UVs = [Vector2(0,  previous_UV_y), Vector2(1, previous_UV_y), Vector2(1, next_UV_y), Vector2(0,next_UV_y)]
		
# 		Switch on the line below in case of using VisualServer instead of draw_polyon:
#		In case of using VisualServer instead of draw_polyon:
#		VisualServer.canvas_item_add_polygon (
#			ci_rid,                                              
#			points,                                  # UVs
#			PoolColorArray(),
#			UVs,                                 
#			slice_sheet.get_rid()                                
#		)

#		Switch off the draw_polygon() in case of using VisualServer instead of draw_polyon:
		draw_polygon ( points, PoolColorArray(),  UVs, slice_sheet )
