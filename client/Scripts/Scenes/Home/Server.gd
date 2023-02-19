const PATH : String = "home/";

static func authenticate(home : Home, is_first : bool = false):
	if home.current_page == "Gameplay" and home.gameplay != null:
		request("gameplay_updates", "gameplay_updated", home);
		home.gameplay.Server.update_passed(home.gameplay);
	home.Core.start_auth(home);

static func request(request_id : String, response_id : String, home : Home, is_first : bool = false):
	System.Server.request(get_request_path(request_id, home, is_first), home, response_id);

static func get_request_path(id : String, home : Home, is_first : bool = false):
	var request_path : String;
	var ids : String = System.Server.ids(home);
	match id:
		"gameplay_updates":
			request_path = "update_gameplay" + ids;
		"return_to_game":
			request_path = "return_to_game.php?id=%d" % home.player_id;
	return PATH + request_path;

static func return_to_game(home : Home):
	request("return_to_game", "returned_to_game", home);
