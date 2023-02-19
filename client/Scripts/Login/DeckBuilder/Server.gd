const PATH : String = "login/deck_builder/";

static func request(request_id : String, response_id : String, deck_builder : LoginDeckBuilder):
	System.Server.request(get_request_path(request_id), deck_builder, response_id);

static func get_request_path(id : String):
	var request_path : String;
	var ids : String = ".php";
	match id:
		"load_cards":
			request_path = "load_cards" + ids;
	return PATH + request_path;

static func load_cards(deck_builder : LoginDeckBuilder):
	request("load_cards", "cards_loaded", deck_builder);
