shader_type canvas_item;

uniform bool flash_white = true;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (flash_white) {
        COLOR = vec4(1.0, 1.0, 1.0, tex_color.a); // fully white with original alpha
    } else {
        COLOR = tex_color;
    }
}
