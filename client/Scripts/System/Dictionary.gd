static func copy(source : Dictionary, dictionary : Dictionary = {}):
	for key in source:
		dictionary[key] = source[key];
	return dictionary
