static func collides(moving_object : Node2D, static_object : Node2D, extra_range : Vector2 = Vector2(0, 0)):
	return vector_to_object(moving_object.global_position, static_object, extra_range);

static func vector_to_object(moving_position : Vector2, object : Node2D, extra_range : Vector2 = Vector2(0, 0)):
	var object_range : Vector2 = object.SIZE / 2;
	var distance : Vector2 = moving_position - object.global_position;
	for axis in ["x", "y"]:
		object_range[axis] += extra_range[axis];
	return collision(object_range, distance);

static func collision(_range : Vector2, distance : Vector2):
	return _range.x > abs(distance.x) and _range.y > abs(distance.y);

static func with_mouse(object : Node2D):
	return vector_to_object(object.get_global_mouse_position(), object);
