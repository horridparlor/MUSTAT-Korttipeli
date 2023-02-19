const WAITING_LOBBY_PATH : String = "res://Prefabs/Gameplay/WaitingLobby.tscn";
const YOU_LOST_PATH : String = "res://Prefabs/Gameplay/YouLost.tscn";
const YOU_TIED_PATH : String = "res://Prefabs/Gameplay/YouTied.tscn";
const YOU_WON_PATH : String = "res://Prefabs/Gameplay/YouWon.tscn";

static func activate(gameplay : Gameplay):
	gameplay.activation_timer.start();
	purge_waiting_lobby(gameplay);

static func deactivate(gameplay : Gameplay):
	gameplay.active = false;

static func wait_for_opponent(game_id : int, gameplay : Gameplay):
	update_id(game_id, gameplay);
	if gameplay.waiting_lobby == null:
		gameplay.waiting_lobby = System.Instance.load_child(WAITING_LOBBY_PATH, gameplay);
		gameplay.waiting_lobby.connect("quit", gameplay, "return_home");
	gameplay.enemy_wait_timer.start();

static func purge_waiting_lobby(gameplay : Gameplay):
	var waiting_lobby : GameplayWaitingLobby = gameplay.waiting_lobby;
	if waiting_lobby != null:
		waiting_lobby.queue_free();
		gameplay.waiting_lobby = null;

static func update_id(game_id : int, gameplay : Gameplay):
	if game_id == -1 and gameplay.game_id > 0:
		return;
	gameplay.game_id = game_id;
	gameplay.emit_signal("game_named");

static func show_winner(data : Array, gameplay : Gameplay):
	var end_message_path : String = YOU_TIED_PATH;
	var winner_id : int;
	System.Convert.numerice(data);
	if data.size() == 0:
		winner_id = -1;
		System.debug("Error: Winner undetermined!");
	else:
		winner_id = data[0];
	if winner_id == gameplay.player_id:
		end_message_path = YOU_WON_PATH;
	elif winner_id == gameplay.enemy_id:
		end_message_path = YOU_LOST_PATH;
	instance_end_message(end_message_path, gameplay);

static func instance_end_message(end_message_path : String, gameplay : Gameplay):
	gameplay.end_message = System.Instance.load_child(end_message_path, gameplay.end_messages);
	gameplay.end_message.activate_animations(gameplay.random);
	gameplay.end_message.connect("log_out", gameplay, "return_home");
