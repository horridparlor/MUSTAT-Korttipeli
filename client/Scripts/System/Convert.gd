static func numerice(data : Array, exceptions : Array = []):
	for i in range(data.size()):
		if data[i] == null:
			data[i] = -1;
		else:
			if !i in exceptions:
				data[i] = int(data[i]);
	return data;

static func namelize(string : String):
	return string[0].to_upper() + string.substr(1, -1);

static func bool_to_string(boolean : bool):
	return str(int(boolean));

static func array_to_string(array : Array):
	var string_form : String = str(array).replace(" ", "");
	return string_form;
