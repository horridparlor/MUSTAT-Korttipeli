const DECK_BUILDER_PATH : String = "res://Prefabs/Nexus/DeckBuilder.tscn";
const GAME_CENTER_PATH : String = "res://Prefabs/Nexus/GameCenter.tscn";
const VARIANT_SHOP_PATH : String = "res://Prefabs/Nexus/VariantShop.tscn";

static func open_page(page_name : String, nexus : Nexus):
	purge_active_page(nexus);
	match page_name:
		"DeckBuilder":
			open_deck_builder(nexus);
		"GameCenter":
			open_game_center(nexus);
		"VariantShop":
			open_variant_shop(nexus)

static func purge_active_page(nexus : Nexus):
	var active_page : NexusContentPage = nexus.active_page;
	if active_page != null:
		nexus.active_page = null;
		active_page.pop();

static func open_deck_builder(nexus : Nexus):
	load_page(DECK_BUILDER_PATH, nexus);
	nexus.active_page.init(nexus.random);
	nexus.active_page.connect("save_deck", nexus, "save_deck");

static func open_game_center(nexus : Nexus):
	load_page(GAME_CENTER_PATH, nexus);
	nexus.active_page.connect("enter_game", nexus, "enter_game");

static func open_variant_shop(nexus : Nexus):
	load_page(VARIANT_SHOP_PATH, nexus);

static func load_page(page_path : String, nexus : Nexus):
	var page : NexusContentPage = System.Instance.load_child(page_path, nexus.page_layer);
	nexus.active_page = page;
	for signal_ in ["highlight"]:
		nexus.active_page.connect(signal_, nexus, signal_);
