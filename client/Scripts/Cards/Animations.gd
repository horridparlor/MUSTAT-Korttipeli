extends CardAnimations

func _ready():
	alpha_timer = System.Instance.timer(0.2, "", self);

func toggle_motion(boolean : bool, motion_path : String = ""):
	if boolean:
		if motion_path == current_motion_path:
			pass; 
		elif motion != null:
			motion.queue_free();
		else:
			motion = System.Instance.load_child(motion_path, self.motions_layer);
			current_motion_path = motion_path;
		alpha_direction = 1;
		alpha_speed = FADE_IN_SPEED;
	else:
		alpha_direction = -1;
		alpha_speed = FADE_OUT_SPEED;
	alpha_timer.start();

func _physics_process(delta):
	motions_layer.modulate.a += alpha_direction * alpha_speed * delta;
	motions_layer.modulate.a = System.Scale.floats(motions_layer.modulate.a, 0, MAX_ALPHA);
