const INDIFFERENT_DISTANCE : float = 0.01;

static func is_default(vector : Vector2):
	return is_same(vector, default());

static func default():
	return Vector2(0, 0);

static func is_same(vector_a : Vector2, vector_b : Vector2, extra_distance : float = 0):
	return vector_a.distance_to(vector_b) <= INDIFFERENT_DISTANCE + extra_distance;
