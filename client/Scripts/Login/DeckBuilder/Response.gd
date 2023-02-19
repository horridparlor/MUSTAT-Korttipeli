static func route(id : String, data : Array, deck_builder : LoginDeckBuilder):
	match id:
		"cards_loaded":
			deck_builder.Core.instance_cards(data, deck_builder);
