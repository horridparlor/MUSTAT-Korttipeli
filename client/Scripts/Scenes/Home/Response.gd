static func route(id : String, data : Array, home : Home):
	match id:
		"gameplay_updated":
			process_gameplay_updates(data, home);
		"returned_to_game":
			return_to_game(data, home);

static func process_gameplay_updates(data : Array, home : Home):
	if home.current_page == "Gameplay" and home.gameplay != null:
		if data.size() == 0:
			home.log_out();
			return;
		home.gameplay.Cards.update_cards(data, home.gameplay);
		
static func return_to_game(data : Array, home : Home):
	var game_id : int = data[0];
	home.game_id = game_id;
	home.PageLoader.open_gameplay_page(game_id, home);
	home.Server.authenticate(home);
