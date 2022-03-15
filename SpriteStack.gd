tool
extends MultiMeshInstance

export var stack_sheet : Texture = null setget setStackSheet
export var cols : int = 1 setget setCols
export var rows : int = 1 setget setRows

func setStackSheet(param1):
	stack_sheet = param1
	_ready()

func setRows(param1):
	rows = param1
	_ready()

func setCols(param1):
	cols = param1
	_ready()

# Size of a "Pixel" in 3D Space
var px = 0.025

func _ready():
	if not stack_sheet:
		print('Could not render ', get_name(), '. stack_sheet is null.')
		return
		
	
	# Create a new mesh the size of a sprite.
	var uv_width = (stack_sheet.get_size().x as float / cols) * px
	var uv_height = (stack_sheet.get_size().y as float / rows) * px
	var surface_tool = SurfaceTool.new();
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	# Top left.
	surface_tool.add_color(Color.transparent);
	surface_tool.add_uv(Vector2(0, 0))
	surface_tool.add_vertex(Vector3(-uv_width, 0, uv_height));
	
	# Bottom left
	surface_tool.add_color(Color.transparent);
	surface_tool.add_uv(Vector2(0, 1))
	surface_tool.add_vertex(Vector3(-uv_width, 0, -uv_height));
	
	# Bottom right.
	surface_tool.add_color(Color.transparent);
	surface_tool.add_uv(Vector2(1, 1))
	surface_tool.add_vertex(Vector3(uv_width, 0, -uv_height));
	
	# Top right.
	surface_tool.add_color(Color.transparent);
	surface_tool.add_uv(Vector2(1, 0))
	surface_tool.add_vertex(Vector3(uv_width, 0, uv_height));

	# Add the indices to the surface tool.
	# Because a face is made of up two triangles, we'll need to add six indices.
	# First triangle
	surface_tool.add_index(0);
	surface_tool.add_index(1);
	surface_tool.add_index(2);
	# Second triangle
	surface_tool.add_index(0);
	surface_tool.add_index(2);
	surface_tool.add_index(3);

	# Get the resulting mesh from the surface tool, and apply it to the MeshInstance.
	multimesh = MultiMesh.new()
	multimesh.color_format = MultiMesh.COLOR_FLOAT
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.mesh = surface_tool.commit();
	material_override = material_override.duplicate()
	material_override.set_shader_param('stack_sheet', stack_sheet)
	
	# Need to move up 2x pixels or the stack looks squished
	var up_unit = px + px
	
	
	
	multimesh.instance_count = rows
	for i in range(0, rows):
		multimesh.set_instance_transform(i, Transform(Basis(), Vector3(0, i * up_unit, 0)))
		multimesh.set_instance_color(
			i, 
			Color(
				# Sprite width in UV
				1.0, 
				# Sprite height in UV
				1.0 / rows, 
				# Layer index this instance should render
				rows - i - 1))

