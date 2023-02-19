static func copy(source : Array, array : Array = []):
	for item in source:
		array.append(item);
	return array;

static func random_item(array : Array, random : RandomNumberGenerator):
	return array[random.randi_range(0, array.size() - 1)];
