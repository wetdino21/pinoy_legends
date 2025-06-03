shader_type canvas_item;

uniform bool enable_glow = false;
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0); // Yellow
uniform float glow_thickness = 2.0;
uniform float glow_softness = 1.5; // Controls fade smoothness

// Animation speed: pulses per second (set high for sharp fast pulse)
uniform float pulse_speed = 8.0; 

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
            // Sharp spike pulse between 0 and 1 using fract + step
            float t = fract(TIME * pulse_speed);
            float pulse = step(0.8, t); // Pulse ON only when t > 0.8 (20% of cycle)
            
            // Smoothly fade in/out around the pulse for less harsh edge
            pulse *= smoothstep(0.8, 1.0, t);
            
            float intensity = clamp(glow * glow_softness * pulse, 0.0, 1.0);
            COLOR = vec4(glow_color.rgb, intensity * glow_color.a);
        } else {
            discard;
        }
    }
}



//no animation