shader_type canvas_item;
//render_mode light_only;

// We'll use a screen texture to check if the sprite is behind something
uniform sampler2D screen_texture: hint_screen_texture;
// The color to use for the silhouette
uniform vec4 silhouette_color: source_color= vec4(0.0, 0.0, 0.0, 0.5);

void fragment() {
    // Sample the screen color
    vec4 screen_color = texture(screen_texture, SCREEN_UV);
    // Sample the sprite color
    vec4 sprite_color = texture(TEXTURE, UV);
    // Check if the sprite and the screen color match
    if(all(lessThan(abs(sprite_color - screen_color), vec4(0.01)))) {
        // This means the character is visible
        COLOR = sprite_color;
    } else {
        // This means the character is behind an object
        COLOR = vec4(silhouette_color.rgb, silhouette_color.a * sprite_color.a);
    }
}

//void light() {
//}


//void light() {
	//// Called for every pixel for every light affecting the CanvasItem.
	//// Uncomment to replace the default light processing function with this one.
     //// Only apply lighting if not in silhouette mode
    //vec4 screen_color = texture(screen_texture, SCREEN_UV);
    //vec4 sprite_color = texture(TEXTURE, UV);
//
    //if (all(lessThan(abs(sprite_color - screen_color), vec4(0.01)))) {
        //// Character is visible, apply lighting
        //vec4 lit_color = COLOR * LIGHT;
        //lit_color;
    //}
//}
