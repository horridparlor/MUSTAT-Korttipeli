static func route(id : String, data : Array, gameplay : Gameplay):
	match id:
		"attack_committed":
			"TODO";
		"card_moved":
			gameplay.is_moving_card = false;
			gameplay.Server.move_next_card(gameplay);
		"deck_loaded":
			load_zone(data, gameplay.deck, gameplay);
		"enemy_deck_loaded":
			load_zone(data, gameplay.enemy_deck, gameplay);
		"enemy_field_loaded":
			load_zone(data, gameplay.enemy_field, gameplay);
		"enemy_grave_loaded":
			load_zone(data, gameplay.enemy_grave, gameplay);
		"enemy_hand_loaded":
			load_zone(data, gameplay.enemy_hand, gameplay);
		"field_loaded":
			load_zone(data, gameplay.field, gameplay);
		"game_loaded":
			gameplay.GameState.load_game(data, gameplay);
		"got_winner":
			gameplay.Core.show_winner(data, gameplay);
		"grave_loaded":
			load_zone(data, gameplay.grave, gameplay);
		"hand_loaded":
			load_zone(data, gameplay.hand, gameplay);
		"turn_passed":
			gameplay.turn_passer.eat_state(data);

static func load_zone(data : Array, zone : GameplayZone, gameplay : Gameplay):
	gameplay.GameState.instance_cards(data, zone.ZONE_NAME, gameplay);
