shader_type canvas_item;

//
// Based on camera feed tutorial by ahihi
// https://github.com/ahihi/godot_camerafeed_tutorial/
//

uniform sampler2D camera_y;
uniform sampler2D camera_CbCr;

void fragment() {
	vec3 color;
	color.rgb = texture(camera_y, UV).rgb;
	/*
	color.r = texture(camera_y, UV).r;
	color.gb = texture(camera_CbCr, UV).rg - vec2(0.5, 0.5);

	// YCbCr -> SRGB conversion
	// Using BT.709 which is the standard for HDTV
	color.rgb = mat3(
						vec3(1.00000, 1.00000, 1.00000),
						vec3(0.00000, -0.18732, 1.85560),
						vec3(1.57481, -0.46813, 0.00000)) *
				color.rgb;
	*/
	COLOR = vec4(color, 1.0);
}