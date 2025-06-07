shader_type canvas_item;
render_mode blend_mix, unshaded;

uniform bool enable_glow = true;
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0); // Yellow
uniform float glow_thickness = 2.0;
uniform float glow_softness = 1.5; // Controls fade smoothness

void fragment() {
    vec4 base = texture(TEXTURE, UV);

    if (base.a > 0.01) {
        COLOR = base;
    } else {
        float glow = 0.0;
        vec2 tex_size = vec2(textureSize(TEXTURE, 0));

        // Sample in a 5x5 grid
        for (int x = -2; x <= 2; x++) {
            for (int y = -2; y <= 2; y++) {
                vec2 offset = vec2(float(x), float(y));
                float distance = length(offset);
                if (distance <= glow_thickness) {
                    vec2 sample_uv = UV + offset / tex_size;
                    float alpha = texture(TEXTURE, sample_uv).a;
                    float weight = 1.0 - smoothstep(0.0, glow_thickness, distance);
                    glow += alpha * weight;
                }
            }
        }

        if (enable_glow && glow > 0.0) {
            float intensity = clamp(glow * glow_softness, 0.0, 1.0);
            COLOR = vec4(glow_color.rgb, intensity * glow_color.a);
        } else {
            discard;
        }
    }
}

void light() {
}