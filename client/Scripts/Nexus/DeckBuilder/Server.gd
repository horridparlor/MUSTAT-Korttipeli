const PATH : String = "nexus/deck_builder/";

static func request(request_id : String, response_id : String, deck_builder : NexusDeckBuilder):
	System.Server.request(get_request_path(request_id), deck_builder, response_id);

static func get_request_path(id : String):
	var request_path : String;
	var ids : String = ".php";
	match id:
		"load_cards":
			request_path = "load_cards" + ids;
	return PATH + request_path;

static func load_cards(deck_builder : NexusDeckBuilder):
	if deck_builder.Core.load_cards(deck_builder):
		return;
	request("load_cards", "cards_loaded", deck_builder);
