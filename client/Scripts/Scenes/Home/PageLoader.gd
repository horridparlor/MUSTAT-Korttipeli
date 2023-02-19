const GAMEPLAY_PATH : String = "res://Prefabs/Scenes/Gameplay.tscn";
const NEXUS_PATH : String = "res://Prefabs/Scenes/Nexus.tscn";
const VERSION_ERROR_PAGE : String = "res://Prefabs/Home/ErrorPage.tscn";

static func load_page(path : String, home : Home):
	return System.Instance.load_child(path, home);

static func enter_game(id : int, decklist : Array, home : Home):
	if home.current_page == "Loading_Gameplay":
		return;
	home.player_id = id;
	home.decklist = decklist;
	home.current_page = "Loading_Gameplay";
	home.Server.return_to_game(home);

static func open_gameplay_page(game_id : int, home : Home):
	home.nexus.queue_free();
	home.nexus = null;
	home.gameplay = load_page(GAMEPLAY_PATH, home);
	home.current_page = "Gameplay";
	home.gameplay.Init.init(game_id, home.decklist, home.player_id, home.password, home.random, home.gameplay);
	connect_gameplay(home);

static func logged_out(home : Home, message : String = ""):
	open_nexus(home);

static func connect_gameplay(home : Home):
	var gameplay : Gameplay = home.gameplay;
	for _signal in ["log_out", "game_named"]:
		gameplay.connect(_signal, home, _signal);

static func open_nexus(home : Home):
	if home.gameplay != null:
		home.gameplay.queue_free();
		home.gameplay = null;
	home.nexus = load_page(NEXUS_PATH, home);
	home.nexus.Init.init(home.random, home.nexus);
	home.nexus.connect("enter_game", home, "enter_game");

static func old_version(home : Home):
	load_page(VERSION_ERROR_PAGE, home);
