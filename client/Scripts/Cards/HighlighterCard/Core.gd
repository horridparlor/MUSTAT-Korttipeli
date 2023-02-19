static func eat(card : GameplayCard, high_card : HighlighterCard):
	for id in ["base_id", "variant_id"]:
		high_card[id] = card[id];
	System.Cards.update_visuals(card, high_card);
	high_card.variant_download_request = card.Server.route_request_path("load_variant", card, 4);

static func play_sound(location : String, data : PoolByteArray, high_card : HighlighterCard, do_store : bool = true):
	System.Cards.Sound.play(location, high_card, data, high_card.sound_player, do_store);
