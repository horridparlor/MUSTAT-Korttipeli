const FILE_STORAGE_PREFIX : String = "user://card_id=";
const FILE_STORAGE_MIDFIX_1 : String = "&variant_id=";
const FILE_STORAGE_MIDFIX_2 : String = "&location=";
const FILE_STORAGE_SUBFIX : String = ".sound";

static func load_sound(card : Card):
	var sound_data : PoolByteArray = find_existing_sound(card);
	if sound_data.size() > 0 and !System.Force.SOUND_REDOWNLOADS:
		card.Core.play_sound(System.Cards.Sound.normalized_location(card), sound_data, card, false);
		return;
	card.Server.load_sound(card);

static func find_existing_sound(card : Card):
	var sound_data : PoolByteArray = [];
	var file_storage : File = File.new();
	var file_path : String = get_sound_storage_path(card);
	if file_storage.file_exists(file_path):
		file_storage.open(file_path, File.READ);
		sound_data = file_storage.get_var();
		file_storage.close();
	return sound_data;

static func store_sound(location : String, sound_data : PoolByteArray, card : Card):
	var file_storage : File = File.new();
	file_storage.open(get_sound_storage_path(card, location), File.WRITE);
	file_storage.store_var(sound_data);
	file_storage.close();

static func get_sound_storage_path(card : Card, location : String = "Null"):
	if location == "Null":
		location = normalized_location(card);
	return FILE_STORAGE_PREFIX + str(card.base_id) + FILE_STORAGE_MIDFIX_1 +\
	str(card.variant_id) + FILE_STORAGE_MIDFIX_2 + \
	location + FILE_STORAGE_SUBFIX;

static func normalized_location(card : Card):
	var location : String = card.location.to_lower();
	if "hand" in location:
		location = "hand";
	elif "field" in location:
		location = "field";
	elif "grave" in location:
		location = "grave";
	return location;

static func play(location : String, card : Card, data : PoolByteArray, sound_player : AudioStreamPlayer, do_store : bool = false):
	var stream : AudioStreamMP3 = AudioStreamMP3.new();
	if data.size() < 16:
		return;
	stream.data = data;
	sound_player.stream = stream;
	sound_player.play();
	if do_store:
		store_sound(location, data, card);
