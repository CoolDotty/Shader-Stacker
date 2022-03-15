shader_type spatial;
render_mode unshaded;

uniform sampler2D stack_sheet : hint_albedo;

void fragment() {
	float layer_height = COLOR.g;
	float layer_index = COLOR.b;
	vec4 albedo_tex = texture(stack_sheet, UV * vec2(1, layer_height) + vec2(0, layer_index * layer_height));
	ALPHA = albedo_tex.a;
	ALBEDO = albedo_tex.rgb;
}