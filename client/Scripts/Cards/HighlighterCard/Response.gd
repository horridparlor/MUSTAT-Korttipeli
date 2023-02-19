static func route(id : String, data : Array, high_card : HighlighterCard):
	match id:
		"field_sound_loaded":
			high_card.Core.play_sound("field", data[0], high_card);
		"grave_sound_loaded":
			high_card.Core.play_sound("grave", data[0], high_card);
		"hand_sound_loaded":
			high_card.Core.play_sound("hand", data[0], high_card);
		"variant_loaded":
			System.Cards.Variants.update_artwork(data[0], high_card);
