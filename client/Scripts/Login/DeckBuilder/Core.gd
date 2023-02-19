static func instance_cards(data : Array, deck_builder : LoginDeckBuilder):
	for identifier in data:
		System.Convert.numerice(identifier)
		instance_card(identifier, deck_builder);
	deck_builder.CardMovement.load_decklist(deck_builder);

static func instance_card(identifier : Array, deck_builder : LoginDeckBuilder):
	var instance_id : int = System.Id.generate(deck_builder.random);
	var indicator : CardIndicator = CardIndicator.new(-1, instance_id, identifier[0], 0, "BuilderStack");
	var card : GameplayCard = System.Instance.card(indicator, deck_builder);
	deck_builder.CardMovement.add_to_builder_stack(card, deck_builder, false);
