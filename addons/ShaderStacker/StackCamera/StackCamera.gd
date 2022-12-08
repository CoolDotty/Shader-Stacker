extends Camera2D
class_name StackCamera


var stackGroupName


func _ready():
	var id = get_viewport().get_viewport_rid().get_id()
	stackGroupName = "zsort{viewportRID}".format({ "viewportRID": id })


func _process(delta):
	if not current:
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

func screen_top_down_sort(a, b):
	return a.global_position.rotated(-global_rotation).y < b.global_position.rotated(-global_rotation).y
