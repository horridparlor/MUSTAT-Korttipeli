const CARD_PATH : String = "res://Prefabs/Cards/GameplayCard.tscn";

static func load_child(child_path : String, parent : Node):
	var child : Node = load(child_path).instance();
	parent.add_child(child);
	return child;

static func card(indicator : CardIndicator, card_holder : CardHolder):
	var card : GameplayCard = load_child(CARD_PATH, card_holder.cards);
	System.Cards.init(card, indicator, card_holder);
	return card;

static func nexus_card(indicator : CardIndicator, content_page : NexusContentPage):
	var card : GameplayCard = load_child(CARD_PATH, content_page.cards);
	System.Cards.nexus_init(card, indicator, content_page);
	return card;

static func timer(wait_time : float, timeout_method : String, parent : Node):
	var timer : Timer = Timer.new();
	parent.add_child(timer);
	timer.wait_time = wait_time;
	timer.connect("timeout", parent, timeout_method);
	return timer;

static func instant_timer(timeout_method : String, parent : Node):
	return timer(0.01, timeout_method, parent);
