shader_type spatial;
render_mode cull_front;

uniform vec3 outline_color = vec3(0.1, 0.1, 0.1);
uniform float outline_width = 0.015;

void vertex() {
    VERTEX += NORMAL * outline_width;
}

void fragment() {
    ALBEDO = outline_color;
}
