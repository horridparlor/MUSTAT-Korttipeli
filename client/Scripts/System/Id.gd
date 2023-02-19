const PLAYER_ID_PATH : String = "user://player_id.save";

static func generate(random : RandomNumberGenerator):
	return random.randi_range(0, pow(10, 8) - 1);
	
static func get_player_id(random : RandomNumberGenerator):
	var player_id : int = load_player_id();
	if player_id < 0:
		player_id = generate(random);
		store_player_id(player_id);
	return player_id;

static func load_player_id():
	var file : File = File.new();
	var player_id : int = -1;
	if file.file_exists(PLAYER_ID_PATH):
		file.open(PLAYER_ID_PATH, file.READ);
		player_id = file.get_var();
		file.close();
	return player_id;

static func store_player_id(player_id : int):
	var file : File = File.new();
	file.open(PLAYER_ID_PATH, file.WRITE);
	file.store_var(player_id);
	file.close();
