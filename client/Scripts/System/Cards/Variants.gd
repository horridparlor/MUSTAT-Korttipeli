const FILE_STORAGE_PREFIX : String = "user://card_id=";
const FILE_STORAGE_MIDFIX_1 : String = "&variant_id=";
const FILE_STORAGE_MIDFIX_2 : String = "&scale=";
const FILE_STORAGE_SUBFIX : String = ".variant";

static func needs_download(card : Card, force_redownload : bool = false):
	if System.Stop.CARD_VARIANTS:
		return false;
	elif !(force_redownload or (System.Force.VARIANT_REDOWNLOADS and \
	(System.Force.REDOWNLOAD_FILTER == -1 or System.Force.REDOWNLOAD_FILTER == card.base_id))) \
	and load_variant_from_system(card):
		return false;
	return true;

static func update_artwork(data : PoolByteArray, card : Card):
	if set_artwork(data, card):
		return;
	store_variant_to_system(data, card);

static func set_artwork(data : PoolByteArray, card : Card):
	var image : Image = Image.new();
	var image_error : int = image.load_png_from_buffer(data);
	var texture : ImageTexture = ImageTexture.new();
	if data.size() == 0 or image_error:
		card.Server.load_variant(card);
		return true;
	texture.create_from_image(image);
	card.activate_visuals(texture, card.random);
	return false;

static func store_variant_to_system(data : PoolByteArray, card : Card):
	variant_storage("Store", card, data);

static func load_variant_from_system(card : Card):
	return variant_storage("Load", card, []);

static func variant_storage(action : String, card : Card, data : PoolByteArray = []):
	var file_storage : File = File.new();
	var file_path : String = get_variant_storage_path(card);
	match action:
		"Store":
			save_variant(file_storage, file_path, data);
		"Load":
			var dir = Directory.new();
			return load_variant(file_storage, file_path, card);
	file_storage.close();

static func save_variant(file_storage : File, file_path : String, data : PoolByteArray):
	file_storage.open(file_path, File.WRITE);
	file_storage.store_var(data);
	file_storage.close();

static func load_variant(file_storage : File, file_path : String, card : Card):
	var variant_data : PoolByteArray;
	if !file_storage.file_exists(file_path):
		System.debug("Loaded: " + file_path);
		return false;
	file_storage.open(file_path, File.READ);
	variant_data = file_storage.get_var();
	file_storage.close();
	if variant_data.size() > 0:
		set_artwork(variant_data, card);
		return true;
	return false;

static func get_variant_storage_path(card : Card):
	return FILE_STORAGE_PREFIX + str(card.base_id) + \
	FILE_STORAGE_MIDFIX_1 + str(card.variant_id) + FILE_STORAGE_MIDFIX_2 + \
	str(card.variant_scale) + FILE_STORAGE_SUBFIX;
