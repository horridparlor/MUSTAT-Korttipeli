static func route(id : String, data : Array, card : GameplayCard):
	match id:
		"base_stats_loaded":
			if System.Test.data_collapses(data):
				card.Server.load_base_stats(card);
				return;
			card.Indicators.eat_base_stats(data[0], card, true);
		"field_sound_loaded":
			card.Core.play_sound("field", data[0], card);
		"grave_sound_loaded":
			card.Core.play_sound("grave", data[0], card);
		"hand_sound_loaded":
			card.Core.play_sound("hand", data[0], card);
		"variant_loaded":
			System.Cards.Variants.update_artwork(data[0], card);
