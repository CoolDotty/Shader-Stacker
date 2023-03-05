extends Camera2D
class_name StackCamera


var stackGroupName


func _ready():
	var id = get_viewport().get_viewport_rid().get_id()
	stackGroupName = "zsort{viewportRID}".format({ "viewportRID": id })
	self.ignore_rotation = false


func _process(delta):
	if not enabled:
		return
	var tree = get_tree()
	if not tree:
		return
	
	var spritestack_nodes = get_tree().get_nodes_in_group(stackGroupName)
	spritestack_nodes.sort_custom(screen_top_down_sort)
	
	var z = 0 - spritestack_nodes.size() / 2
	for i in range(0, spritestack_nodes.size()):
		spritestack_nodes[i].z_index = z
		spritestack_nodes[i].z_as_relative = false
		z += 1

func get_z_level(node):
	var node_z = 0
	if node is SpriteStack or node is Reset2D:
		node_z = node.z
	return node_z

func screen_top_down_sort(a, b):
	var a_z = get_z_level(a)
	var b_z = get_z_level(b)
	if a_z != b_z:
		return a_z > b_z
	else:
		return a.global_position.rotated(-global_rotation).y < b.global_position.rotated(-global_rotation).y
