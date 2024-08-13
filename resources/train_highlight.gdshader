shader_type spatial;

uniform bool enabled = false;
uniform float pulse_time = 3.0;
uniform vec3 highlight_color : source_color = vec3(0.2, 0.8, 0.2);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (enabled) 
	{
		ALPHA = 0.3 * sin((1.0 / pulse_time) * PI * TIME) + 0.5;
		ALBEDO = highlight_color;
	}
	else
	{
		ALPHA = 0.0;
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
