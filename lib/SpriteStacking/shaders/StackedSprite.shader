shader_type canvas_item;

uniform float y_pos;

void vertex() {
	VERTEX = VERTEX;// + vec2(0, y_pos / 2.0);
//	VERTEX = (EXTRA_MATRIX * (WORLD_MATRIX * vec4(VERTEX, 0.0, 1.0))).xy;
}
