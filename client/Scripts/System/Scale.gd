const WITHER : int = 10;
const MIN_BASE : float = 1.0 / 100;

static func floats(value : float, min_value : float, max_value : float):
	return min(max(value, min_value), max_value);

static func vectors(vector : Vector2, min_vector : Vector2, max_vector : Vector2):
	for axis in ["x", "y"]:
		vector[axis] = floats(vector[axis], min_vector[axis], max_vector[axis]);
	return vector;

static func baseline(value : float, delta : float):
	value -= WITHER * value * delta;
	if abs(value) < MIN_BASE:
		value = 0;
	return value;
