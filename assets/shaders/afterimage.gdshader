shader_type canvas_item;

uniform float fade : hint_range(0.0, 1.0) = 1.0;
uniform vec4 afterimage_color : source_color = vec4(1.0, 1.0, 0.0, 0.5); // Yellow with 50% transparency

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    // Use only the alpha from the texture, color is always yellow
    COLOR = afterimage_color;
    COLOR.a *= tex.a * fade;
}