shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixel_size : hint_range(1.0, 10.0) = 4.0;

void fragment()
{
	vec2 size = vec2(textureSize(screen_texture, 0));
	vec2 uv = floor(SCREEN_UV * size / pixel_size) * pixel_size / size;
	COLOR = texture(screen_texture, uv);
}