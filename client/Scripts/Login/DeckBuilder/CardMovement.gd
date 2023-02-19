const COLLECTION_MARGIN : int = 85;
const COLLECTION_HEIGHT : int = -100;
const COLLECTION_HEIGHT_MARGIN : int = 250;
const DECK_HEIGHT : int = -700;
const ROW_SIZE : int = 6;

const DECKLIST_SAVE_PATH = "user://decklist.save";

static func add_to_builder_stack(card : GameplayCard, deck_builder : LoginDeckBuilder, do_append : bool = true):
	pull_card(card, deck_builder);
	if do_append:
		deck_builder.own_cards.append(card);
	card.card_slot = deck_builder.own_cards.size();
	card.location = "BuilderStack";

static func add_to_deck(card : GameplayCard, deck_builder : LoginDeckBuilder):
	pull_card(card, deck_builder);
	deck_builder.enemy_cards.append(card);
	card.card_slot = deck_builder.enemy_cards.size();
	card.location = "InDeck";

static func pull_card(card : GameplayCard, deck_builder : LoginDeckBuilder):
	var storage : Array;
	match card.location:
		"BuilderStack":
			storage = deck_builder.own_cards;
		"InDeck":
			storage = deck_builder.enemy_cards;
	System.Cards.pull_card(card, storage);

static func reorder(deck_builder : LoginDeckBuilder):
	deck_builder.toggle_play_button();
	reorder_collection(deck_builder);
	reorder_deck(deck_builder);

static func reorder_collection(deck_builder : LoginDeckBuilder):
	var collection : Array = deck_builder.own_cards;
	var card_slot : int;
	for card in collection:
		card_slot = get_row_slot(card.card_slot);
		card.target_position = System.Zones.new_position(card_slot, 6, \
		COLLECTION_MARGIN, 0, (card.card_slot - 1) / 6 * COLLECTION_HEIGHT_MARGIN + COLLECTION_HEIGHT);

static func reorder_deck(deck_builder : LoginDeckBuilder):
	var collection : Array = deck_builder.enemy_cards;
	var card_slot : int;
	for card in collection:
		card_slot = get_row_slot(card.card_slot);
		card.target_position = System.Zones.new_position(card_slot, 6, \
		COLLECTION_MARGIN, 0, (card.card_slot - 1) / 6 * COLLECTION_HEIGHT_MARGIN + DECK_HEIGHT);

static func get_row_slot(card_slot : int):
	while card_slot > 6:
		card_slot -= 6;
	return card_slot

static func move_around(card : GameplayCard, deck_builder : LoginDeckBuilder):
	match card.location:
		"BuilderStack":
			if deck_builder.enemy_cards.size() == 12:
				return;
			add_to_deck(card, deck_builder);
		"InDeck":
			add_to_builder_stack(card, deck_builder);
	reorder(deck_builder);
	save_decklist(deck_builder);

static func save_decklist(deck_builder : LoginDeckBuilder):
	var file_storage : File = File.new();
	file_storage.open(DECKLIST_SAVE_PATH, File.WRITE);
	file_storage.store_var(convert_decklist(deck_builder));
	file_storage.close();

static func load_decklist(deck_builder : LoginDeckBuilder):
	var file_storage : File = File.new();
	var file_path : String = DECKLIST_SAVE_PATH;
	var decklist : Array;
	if file_storage.file_exists(file_path):
		file_storage.open(file_path, File.READ);
		decklist = file_storage.get_var();
		file_storage.close();
	initialize_decklist(decklist, deck_builder);
	reorder(deck_builder);

static func initialize_decklist(decklist : Array, deck_builder : LoginDeckBuilder):
	for base_id in decklist:
		for card in deck_builder.own_cards:
			if card.base_id == base_id:
				move_around(card, deck_builder)
				break;

static func convert_decklist(deck_builder : LoginDeckBuilder):
	var base_ids : Array;
	for card in deck_builder.enemy_cards:
		base_ids.append(card.base_id);
	return base_ids;

const FILE_STORAGE_PREFIX : String = "user://card_id=";
const FILE_STORAGE_MIDFIX_1 : String = "&variant_id=";
const FILE_STORAGE_MIDFIX_2 : String = "&location=";
const FILE_STORAGE_SUBFIX : String = ".sound";

static func load_sound(card : GameplayCard):
	var sound_data : PoolByteArray = find_existing_sound(card);
	if sound_data.size() > 0 and !System.Force.SOUND_REDOWNLOADS:
		card.Core.play_sound(sound_data, card, false);
		return;
	card.Server.load_sound(card);

static func find_existing_sound(card : GameplayCard):
	var sound_data : PoolByteArray = [];
	var file_storage : File = File.new();
	var file_path : String = get_sound_storage_path(card);
	if file_storage.file_exists(file_path):
		file_storage.open(file_path, File.READ);
		sound_data = file_storage.get_var();
		file_storage.close();
	return sound_data;

static func store_sound(sound_data : PoolByteArray, card : GameplayCard):
	var file_storage : File = File.new();
	file_storage.open(get_sound_storage_path(card), File.WRITE);
	file_storage.store_var(sound_data);
	file_storage.close();

static func get_sound_storage_path(card : Card):
	return FILE_STORAGE_PREFIX + str(card.base_id) + FILE_STORAGE_MIDFIX_1 +\
	str(card.variant_id) + FILE_STORAGE_MIDFIX_2 + \
	normalized_location(card) + FILE_STORAGE_SUBFIX;

static func normalized_location(card : GameplayCard):
	var location : String = card.location.to_lower();
	if "hand" in location:
		location = "hand";
	elif "field" in location:
		location = "field";
	elif "grave" in location:
		location = "grave";
	return location;
