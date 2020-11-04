shader_type canvas_item;
render_mode unshaded;
// TODO: Uncomment this when Godot ports this statement and remove all lowp
//precision lowp int, float, vec2;

uniform sampler2D slice_sheet : hint_black;
uniform lowp int columns : hint_range(1, 64);
uniform lowp int rows : hint_range(1, 64);
uniform lowp int layer_count : hint_range(1, 64);
uniform lowp float stretch : hint_range(1, 3);
uniform lowp int center : hint_range(0, 63);

const lowp float PI = 3.14159265358979323846;
const lowp float HALF_PI = 3.14159265358979323846 / 2f;

// Current rotation. Relative to camera + any other transformations
varying lowp float rot;

// Gets color on layer.
// layer: index of layer in interval {0 < uv < layer_count}
// uv: coord of color in interval {0 < uv < 1.0}
// LIMITATION: Out of bounds will repeat the outermost pixel!
// FIX: Keep a transparent border around all layers
lowp vec4 getColorOnLayer(lowp int layer, lowp vec2 uv) {
	lowp vec2 slice_size = vec2(1f / float(columns), 1f / float(rows));
	lowp vec2 layer_start = vec2(float(layer % columns), float(layer / columns)) * slice_size;
	lowp vec4 tex_col = texture(slice_sheet, layer_start + slice_size * clamp(uv, 0, 1f));
	return tex_col;
}

void vertex(){
	rot = atan(WORLD_MATRIX[1][0], WORLD_MATRIX[1][1]) - HALF_PI;
	
	lowp vec2 up_vector = vec2(cos(rot), sin(rot));

	lowp vec2 size_pix = vec2(textureSize(slice_sheet, 0));
	lowp vec2 LAYER_SIZE_IN_PIXELS = (size_pix / vec2(ivec2(columns, rows)));
	lowp vec2 LAYER_PIXEL_SIZE_IN_UV = 1f / LAYER_SIZE_IN_PIXELS;

	lowp vec2 extra_space = float(layer_count) * LAYER_PIXEL_SIZE_IN_UV * stretch;

	lowp vec2 layer_space = VERTEX * (1f + abs(extra_space * up_vector));
	layer_space += floor(float(layer_count - center) * stretch) * up_vector / 2f;
	VERTEX = layer_space;
}

void fragment() {
	lowp vec2 size_pix = vec2(textureSize(slice_sheet, 0));
	lowp vec2 LAYER_SIZE_IN_PIXELS = (size_pix / vec2(ivec2(columns, rows)));
	lowp vec2 LAYER_PIXEL_SIZE_IN_UV = 1f / LAYER_SIZE_IN_PIXELS;
	
	lowp vec2 up_vector = vec2(cos(rot), sin(rot));
	lowp vec2 stack_vector = LAYER_PIXEL_SIZE_IN_UV * up_vector;
	
	// Shrink range so there's enough room to show stacks
	lowp vec2 OldMin = vec2(0);
	lowp vec2 OldMax = vec2(1f);
	lowp vec2 OldRange = OldMin - OldMax;
	lowp vec2 NewMin = vec2(0) - max(float(layer_count) * stretch * stack_vector, vec2(0));
	lowp vec2 NewMax = vec2(1f) - min(float(layer_count) * stretch * stack_vector, vec2(0));
	lowp vec2 NewRange = NewMin - NewMax;
	lowp vec2 layer_uv = (((UV - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin;
	
	lowp vec4 current_color = vec4(0);
	for (lowp int i = 0; i < int(float(layer_count) * stretch); i++) {
		lowp vec2 current_uv = layer_uv + float(i) * stack_vector;
		// Mix colors. Use current color if alpha is 1
		current_color = mix(getColorOnLayer(int(float(i) / stretch), current_uv), current_color, current_color.a);
	}
	COLOR = current_color;
}
