shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

uniform lowp float stretch : hint_range(1, 64);

void vertex() {
	vec2 scale = vec2(
		sqrt(pow(WORLD_MATRIX[0][0], 2) + pow(WORLD_MATRIX[0][1], 2)),
		sqrt(pow(WORLD_MATRIX[1][0], 2) + pow(WORLD_MATRIX[1][1], 2))
	);
	
	mat4 billboard = WORLD_MATRIX;

	billboard[0][0] = scale.x;
	billboard[0][1] = 0f;

	billboard[1][0] = 0f;
	billboard[1][1] = scale.y * stretch;
	
	VERTEX = (EXTRA_MATRIX * (billboard * vec4(VERTEX, 0.0, 1.0))).xy;
}
