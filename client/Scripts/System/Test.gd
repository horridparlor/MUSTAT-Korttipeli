static func is_type(variable, type : int):
	return typeof(variable) == type;

static func is_int(variable):
	return is_type(variable, TYPE_INT);

static func is_float(variable):
	return is_type(variable, 3);
	
static func is_numeric(variable):
	return is_int(variable) or is_float(variable);

static func data_collapses(data : Array):
	return data.size() == 0 or is_numeric(data[0]);

static func is_array(variable):
	return typeof(variable) == 19;
