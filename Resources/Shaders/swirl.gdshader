/*
	godot_swirl_shader by mth2610
	https://github.com/mth2610/godot_swirl_shader

	MIT License
*/

shader_type canvas_item;

void fragment(){
	float pi = 3.14;
	float blur = 10.0;
	float speed = 3.0;
	vec2 position = UV;
	vec2 center = vec2(0.5, 0.5);
	float distance_to_center = distance(position, center);
	float rotation_index = distance_to_center*blur*pi*sin(-TIME/speed);
	
	// move to center
	position -= center;
	
	//apply rotation transformation
	mat2 rotation_matrix = mat2(vec2(sin(rotation_index), -cos(rotation_index)),
								vec2(cos(rotation_index), sin(rotation_index)));
	position = position*rotation_matrix;
	
	//move back 
	position += center;
	
	COLOR = texture(TEXTURE, position);
}