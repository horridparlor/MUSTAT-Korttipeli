static func init(game_id : int, decklist : Array, player_id : int, password : int,
random : RandomNumberGenerator, gameplay : Gameplay):
	gameplay.decklist = decklist;
	gameplay.decklist.shuffle();
	gameplay.Core.update_id(game_id, gameplay);
	gameplay.player_id = player_id;
	gameplay.password = password;
	set_random(random, gameplay);
	start(gameplay);

static func set_random(random : RandomNumberGenerator, gameplay : Gameplay):
	gameplay.random = random;
	gameplay.highlighter.init(gameplay.random);
	for glow_node in [gameplay.log_out, gameplay.mana_bar, gameplay.turn_passer]:
		glow_node.activate_animations(gameplay.random);

static func start(gameplay : Gameplay):
	gameplay.Server.load_game(gameplay);
	connect_signals(gameplay);

static func connect_signals(gameplay : Gameplay):
	gameplay.turn_passer.connect("pass_turn", gameplay, "turn_passed");
	gameplay.turn_passer.connect("game_ended", gameplay, "game_ended");
	gameplay.highlighter.connect("close", gameplay, "close_highlighter");
	gameplay.log_out.connect("log_out", gameplay, "return_home");
