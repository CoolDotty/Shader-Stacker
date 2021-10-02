extends Node2D

func _ready():
	pass


func _process(_delta):
#	print(get_viewport().canvas_transform.get_scale())
#	var up_vector = Vector2(cos(rotation - PI/2), sin(rotation - PI/2));
	var up_vector = Vector2(0, -1).rotated(-rotation)
	var base_vector = Vector2(0.5, 0.5)
	var zoom = Vector2(2.8, 2.8)
	var centered = Transform2D.IDENTITY.translated(get_viewport().size / 2)
	var positioned = Transform2D.IDENTITY.translated(position)
	var rotated = Transform2D.IDENTITY.rotated(-rotation)
	var zoomed = Transform2D.IDENTITY.scaled(zoom)
	var perspective = Transform2D.IDENTITY
	perspective.x = Vector2(1, 0)
	perspective.y = Vector2(0, 0.5)
	var test = Transform2D.IDENTITY
#	test = test.rotated(rotation)
#	test = test.translated(get_viewport().size / 2)
#	test = test.translated(position)
#	test = test.scaled(Vector2(1, 0.5))
	test = test.rotated(rotation)
	
#	get_viewport().set_canvas_transform(get_viewport().get_canvas_transform().translated(position).scaled(Vector2(0.35, 0.35)))
	get_viewport().set_canvas_transform(
#		(centered * positioned * zoomed * rotated * perspective)
		centered * test * perspective
	)
#	print(get_viewport().get_global_canvas_transform())
#	get_viewport().set_canvas_transform(
#		 Transform2D.IDENTITY.scaled(Vector2(1, 0.5))
#	)
#	zoom = base_zoom * base_vector
