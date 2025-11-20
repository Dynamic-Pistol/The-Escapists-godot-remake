shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;


void fragment() {
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
