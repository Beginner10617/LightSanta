shader_type canvas_item;

uniform sampler2D gradient;
uniform float progress : hint_range(0.0, 1.0);

void fragment() {
	COLOR = texture(gradient, vec2(progress, 0.5));
}
