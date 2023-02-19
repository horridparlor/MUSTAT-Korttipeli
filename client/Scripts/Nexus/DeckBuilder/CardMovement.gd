const COLLECTION_MARGIN : int = 85;
const COLLECTION_HEIGHT : int = 0;
const COLLECTION_HEIGHT_MARGIN : int = 250;
const DECK_HEIGHT : int = -565;
const ROW_SIZE : int = 6;

static func add_to_builder_stack(card : GameplayCard, deck_builder : NexusDeckBuilder, do_append : bool = true):
	pull_card(card, deck_builder);
	if do_append:
		store_to_builder_stack(card, deck_builder);
	card.card_slot = deck_builder.card_storage.size();
	card.location = "BuilderStack";

static func store_to_builder_stack(card : Card, deck_builder : NexusDeckBuilder):
	deck_builder.card_storage.append(card);
	deck_builder.cards.add_child(card);

static func add_to_deck(card : GameplayCard, deck_builder : NexusDeckBuilder):
	pull_card(card, deck_builder);
	deck_builder.deck_storage.append(card);
	deck_builder.cards_in_deck.add_child(card);
	card.card_slot = deck_builder.deck_storage.size();
	card.location = "InDeck";

static func pull_card(card : GameplayCard, deck_builder : NexusDeckBuilder):
	var storage : Array;
	var layer : Node2D;
	match card.location:
		"BuilderStack":
			storage = deck_builder.card_storage;
			layer = deck_builder.cards;
		"InDeck":
			storage = deck_builder.deck_storage;
			layer = deck_builder.cards_in_deck;
	System.Cards.pull_card(card, storage);
	if layer != null:
		layer.remove_child(card);

static func reorder(deck_builder : NexusDeckBuilder):
	reorder_collection(deck_builder);
	reorder_deck(deck_builder);

static func reorder_collection(deck_builder : NexusDeckBuilder):
	var collection : Array = deck_builder.card_storage;
	var card_slot : int;
	System.Cards.Sort.order(collection);
	for card in collection:
		card_slot = get_row_slot(card.card_slot);
		card.target_position = System.Zones.new_position(card_slot, 6, \
		COLLECTION_MARGIN, 0, (card.card_slot - 1) / 6 * COLLECTION_HEIGHT_MARGIN + COLLECTION_HEIGHT);

static func reorder_deck(deck_builder : NexusDeckBuilder):
	var collection : Array = deck_builder.deck_storage;
	var card_slot : int;
	System.Cards.Sort.order(collection);
	for card in collection:
		card_slot = get_row_slot(card.card_slot);
		card.target_position = System.Zones.new_position(card_slot, 6, \
		COLLECTION_MARGIN, 0, (card.card_slot - 1) / 6 * COLLECTION_HEIGHT_MARGIN + DECK_HEIGHT);

static func get_row_slot(card_slot : int):
	while card_slot > 6:
		card_slot -= 6;
	return card_slot

static func move_around(card : GameplayCard, deck_builder : NexusDeckBuilder, do_save : bool = false):
	if card == null:
		return;
	match card.location:
		"BuilderStack":
			if deck_builder.deck_storage.size() == 12:
				return;
			add_to_deck(card, deck_builder);
		"InDeck":
			add_to_builder_stack(card, deck_builder);
	reorder(deck_builder);
	if do_save:
		save_decklist(deck_builder);

static func save_decklist(deck_builder : NexusDeckBuilder):
	var file_storage : File = File.new();
	var decklist : Array = convert_decklist(deck_builder);
	file_storage.open(System.Decklist.build_save_path(deck_builder.active_deck_slot), File.WRITE);
	file_storage.store_var(decklist);
	file_storage.close();
	save_nexus_decklist(decklist, deck_builder);

static func save_nexus_decklist(decklist : Array, deck_builder : NexusDeckBuilder):
	deck_builder.emit_signal("save_deck", decklist);

static func load_decklist(slot_index : int, deck_builder : NexusDeckBuilder):
	var decklist : Array = System.Decklist.load(slot_index);
	initialize_decklist(decklist, deck_builder);
	reorder(deck_builder);

static func initialize_decklist(decklist : Array, deck_builder : NexusDeckBuilder):
	var base_id : int;
	var identifier : Array;
	empty_deck(deck_builder);
	for id in decklist:
		for card in deck_builder.all_cards():
			identifier = [];
			if System.Test.is_array(card):
				identifier = System.Array_.copy(card);
			if identifier.size() > 0:
				base_id = card[0];
			else:
				base_id = card.base_id;
			if base_id == id:
				if identifier.size() > 0:
					card = deck_builder.Core.instance_card(identifier, deck_builder);
					deck_builder.Core.release_identifier(identifier, deck_builder);
				move_around(card, deck_builder)
				break;

static func empty_deck(deck_builder : NexusDeckBuilder):
	var remove_pile : Array = System.Array_.copy(deck_builder.deck_storage);
	for card in remove_pile:
		move_around(card, deck_builder);

static func convert_decklist(deck_builder : NexusDeckBuilder):
	var base_ids : Array;
	for card in deck_builder.deck_storage:
		base_ids.append(card.base_id);
	return base_ids;
