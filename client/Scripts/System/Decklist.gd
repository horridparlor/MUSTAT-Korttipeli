const ACTIVE_SLOT_PATH = "user://active_deck_slot.save";
const DECKLIST_SAVE_PATH_PREFIX = "user://decklist_";
const DECKLIST_SAVE_PATH_SUBFIX = ".save";

static func load(slot_index : int = active_slot()):
	var file_storage : File = File.new();
	var file_path : String = build_save_path(slot_index);
	var decklist : Array;
	if file_storage.file_exists(file_path):
		file_storage.open(file_path, File.READ);
		decklist = file_storage.get_var();
		file_storage.close();
	return decklist;

static func build_save_path(slot_index : int):
	return DECKLIST_SAVE_PATH_PREFIX + str(slot_index) + DECKLIST_SAVE_PATH_SUBFIX;

static func active_slot():
	var file : File = File.new();
	var slot_index : int = 1;
	if file.file_exists(ACTIVE_SLOT_PATH):
		file.open(ACTIVE_SLOT_PATH, file.READ);
		slot_index = file.get_var();
		file.close();
	return slot_index;

static func store_active_slot(slot_index : int):
	var file : File = File.new();
	file.open(ACTIVE_SLOT_PATH, file.WRITE);
	file.store_var(slot_index);
	file.close();
