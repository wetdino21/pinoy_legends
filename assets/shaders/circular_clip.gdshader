shader_type canvas_item;

uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // White by default
uniform float radius = 0.5;
uniform float border_thickness = 0.05;

void fragment() {
    vec2 center = vec2(0.5);
    float dist = distance(UV, center);

    if (dist > radius) {
        discard;
    }

    // Calculate border blend (1 = fully border color, 0 = fully texture)
    float border_start = radius - border_thickness;
    float border_factor = smoothstep(radius, border_start, dist);

    vec4 tex_color = texture(TEXTURE, UV);
    COLOR = mix(border_color, tex_color, border_factor);
}
