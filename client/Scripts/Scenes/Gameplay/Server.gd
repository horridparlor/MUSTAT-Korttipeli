extends Node

const PATH = "gameplay/";

static func load_game(gameplay : Gameplay):
	request("load_game", "game_loaded", gameplay);

static func request(request_id : String, response_id : String, gameplay : Gameplay, add_ons : Array = []):
	System.Server.request(get_request_path(request_id, add_ons, gameplay), gameplay, response_id);

static func get_request_path(id : String, add_ons : Array, gameplay : Gameplay):
	var request_path : String;
	var ids : String = System.Server.ids(gameplay);
	var slim_ids : String = ".php?";
	var enemy_ids : String = System.Server.ids(gameplay, false);
	match id:
		"commit_attack":
			request_path = "commit_attack" + slim_ids;
		"get_winner":
			request_path = "get_winner" + ids;
		"load_deck":
			request_path = load_zone("deck", ids);
		"load_enemy_deck":
			request_path = load_zone("deck", enemy_ids);
		"load_enemy_field":
			request_path = load_zone("field", enemy_ids);
		"load_enemy_grave":
			request_path = load_zone("grave", enemy_ids);
		"load_enemy_hand":
			request_path = load_zone("hand", enemy_ids);
		"load_field":
			request_path = load_zone("field", ids);
		"load_game":
			request_path = "load_game" + ids + "&decklist=" + System.Convert.array_to_string(gameplay.decklist);
		"load_grave":
			request_path = load_zone("grave", ids);
		"load_hand":
			request_path = load_zone("hand", ids);
		"move_card":
			request_path = "move_card" + slim_ids;
		"pass_turn":
			request_path = "pass_turn" + ids;
	for add_on in add_ons:
		request_path += build_add_on(add_on);
	return PATH + request_path;

static func load_zone(zone_name : String, ids : String):
	return "load_zone" + ids + "&zone=" + zone_name;

static func build_add_on(add_on : Array):
	return "&" + add_on[0] + "=" + str(add_on[1]).to_lower();

static func move_card(card : GameplayCard, zone_name : String, gameplay : Gameplay):
	gameplay.cards_to_move.append([card.card_id, card.location, zone_name]);
	move_next_card(gameplay);

static func move_next_card(gameplay : Gameplay):
	var next_card : Array;
	if gameplay.cards_to_move.size() > 0 and !gameplay.is_moving_card:
		gameplay.is_moving_card = true;
		next_card = gameplay.cards_to_move[0];
		request("move_card", "card_moved", gameplay, [["card_id", next_card[0]], ["from", next_card[1]], ["to", next_card[2]]]);
		gameplay.cards_to_move.erase(next_card);

static func commit_attack(card : GameplayCard, gameplay : Gameplay):
	var add_ons : Array = [["attacker_id", card.card_id], ["target_id", gameplay.locked_enemy.card_id]];
	request("commit_attack", "attack_committed", gameplay, add_ons);

static func pass_turn(gameplay : Gameplay, do_pass = true):
	request("pass_turn", "turn_passed", gameplay, [["do_pass", System.Convert.bool_to_string(do_pass)]]);

static func update_passed(gameplay : Gameplay):
	pass_turn(gameplay, false);

static func get_winner(gameplay : Gameplay):
	request("get_winner", "got_winner", gameplay);
