const Sort : GDScript = preload("res://Scripts/System/Cards/Sort.gd");
const Sound : GDScript = preload("res://Scripts/System/Cards/Sound.gd");
const Variants : GDScript = preload("res://Scripts/System/Cards/Variants.gd");

static func parse_indicator(data : Array):
	System.Convert.numerice(data, [4]);
	return CardIndicator.new(data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]);

static func init(card : GameplayCard, indicator : CardIndicator, card_holder : CardHolder):
	connect_card(card, indicator, card_holder);
	store_card(card, card_holder);

static func nexus_init(card : GameplayCard, indicator : CardIndicator, content_page : NexusContentPage):
	connect_card(card, indicator, content_page);
	store_nexus_card(card, content_page);

static func connect_card(card : GameplayCard, indicator : CardIndicator, parent : Node2D):
	card.random = parent.random;
	connect_signals(card, parent);
	card.Indicators.instance(indicator, card);

static func connect_signals(card : GameplayCard, parent : Node2D):
	card.connect("focused", parent, "card_focused");
	card.connect("unfocused", parent, "card_unfocused");
	card.connect("pop", parent, "card_popped");
	for signal_ in ["sound_loaded", "long_click", "quick_click"]:
		card.connect(signal_, parent, signal_);

static func store_card(card : GameplayCard, card_holder : CardHolder):
	get_storage(card.player_id, card_holder).append(card);

static func get_storage(player_id : int, card_holder : CardHolder, looking_for_own : bool = true):
	var storage : Array = card_holder.own_cards;
	if (player_id != card_holder.player_id) == looking_for_own:
		storage = card_holder.enemy_cards;
	return storage;

static func store_nexus_card(card : GameplayCard, content_page : NexusContentPage):
	content_page.card_storage.append(card);

static func update_visuals(card : GameplayCard, parent : Card = null):
	if parent == null:
		parent = card;
	parent.name_label.rewrite(card.base_name);
	parent.cost_label.eat(card.get_cost());
	parent.power_label.eat(card.get_power());

static func pull_card(card : GameplayCard, storage : Array):
	storage.erase(card);
	card.animations.toggle_motion(false);
	update_storage_slots(card.card_slot, storage);

static func update_storage_slots(removed_slot : int, storage : Array):
	for card in storage:
		if card.card_slot > removed_slot:
			card.card_slot -= 1;
