const CARDS_STORAGE_PATH : String = "user://cards.save";

static func instance_cards(data : Array, deck_builder : NexusDeckBuilder, do_store : bool = true):
	if do_store:
		store_cards(data, deck_builder);
	for identifier in data:
		System.Convert.numerice(identifier)
		if deck_builder.card_storage.size() > deck_builder.MAX_CARDS_VISIBLE:
			add_front_of_collection(identifier, deck_builder)
			continue;
		instance_card(identifier, deck_builder);
	deck_builder.CardMovement.load_decklist(System.Decklist.active_slot(), deck_builder);

static func add_front_of_collection(identifier : Array, deck_builder : NexusDeckBuilder):
	identifier.append(1);
	deck_builder.cards_front_collection.append(identifier);

static func add_first_front_of_collection(identifier : Array, deck_builder : NexusDeckBuilder):
	identifier.append(1);
	deck_builder.cards_front_collection = [identifier] + deck_builder.cards_front_collection;

static func add_back_of_collection(identifier : Array, deck_builder : NexusDeckBuilder):
	identifier.append(0);
	deck_builder.cards_back_collection.append(identifier);

static func hide_back(deck_builder : NexusDeckBuilder):
	var card : GameplayCard = deck_builder.card_storage[deck_builder.card_storage.size() - 1];
	var identifier : Array = card.Indicators.get_identifier(card);
	deck_builder.card_storage.erase(card);
	card.queue_free();
	add_back_of_collection(identifier, deck_builder);
	
static func hide_front(deck_builder : NexusDeckBuilder):
	var card : GameplayCard = deck_builder.card_storage[0];
	var identifier : Array = card.Indicators.get_identifier(card);
	deck_builder.card_storage.erase(card);
	card.queue_free();
	add_first_front_of_collection(identifier, deck_builder);

static func instance_card(identifier : Array, deck_builder : NexusDeckBuilder):
	var instance_id : int = System.Id.generate(deck_builder.random);
	var indicator : CardIndicator = CardIndicator.new(-1, instance_id, identifier[0], 0, "BuilderStack");
	var card : GameplayCard = System.Instance.nexus_card(indicator, deck_builder);
	deck_builder.CardMovement.add_to_builder_stack(card, deck_builder, false);
	card.teleport();
	return card;

static func load_cards(deck_builder : NexusDeckBuilder):
	var storage : File = File.new();
	var cards : Dictionary;
	if !storage.file_exists(CARDS_STORAGE_PATH):
		return;
	storage.open(CARDS_STORAGE_PATH, storage.READ);
	cards = storage.get_var();
	storage.close();
	if cards.session_id == System.session_id:
		instance_cards(cards.data, deck_builder, false);
		return true;
	return false;

static func store_cards(data : Array, deck_builder : NexusDeckBuilder):
	var storage : File = File.new();
	var cards_var : Dictionary = {
		"session_id" : System.session_id,
		"data" : data
	};
	storage.open(CARDS_STORAGE_PATH, storage.WRITE);
	storage.store_var(cards_var);
	storage.close();

static func release_identifier(identifier : Array, deck_builder : NexusDeckBuilder):
	var storage : Array = deck_builder.cards_back_collection;
	if identifier[2] == 1:
		storage = deck_builder.cards_front_collection;
	storage.erase(identifier);
