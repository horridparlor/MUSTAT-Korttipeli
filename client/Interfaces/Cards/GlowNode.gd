extends Node2D
class_name GlowNode

const MAX_TOP_GLOW : float = 1.5;
const MIN_TOP_GLOW : float = 1.125;
const MAX_SPEED : float = 0.25;
const MIN_SPEED : float = 0.0625;

var animations_active : bool;
var glow_intensity : float = 1.0;
var glowing_direction : int = 1;
var glow_speed : float;
var top_glow : float;

func _physics_process(delta : float):
	animation_frame(delta);
	physics_frame(delta);

func physics_frame(delta : float):
	pass;

func animation_frame(delta : float):
	if !animations_active:
		return;
	glow_intensity += glowing_direction * glow_speed * delta;
	if glowing_direction == 1 and glow_intensity >= top_glow or \
	glowing_direction == -1 and glow_intensity <= 1.0:
		glowing_direction *= -1;
	modulate = Color(glow_intensity, glow_intensity, glow_intensity);

func activate_animations(random : RandomNumberGenerator):
	if animations_active:
		return;
	top_glow = random.randf_range(MIN_TOP_GLOW, MAX_TOP_GLOW);
	glow_intensity = random.randf_range(1.0, top_glow);
	glow_speed = random.randf_range(MIN_SPEED, MAX_SPEED);
	animations_active = true

func deactivate_animations():
	animations_active = false;
