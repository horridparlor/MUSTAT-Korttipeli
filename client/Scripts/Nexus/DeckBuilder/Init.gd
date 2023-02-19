static func init(random : RandomNumberGenerator, deck_builder : NexusDeckBuilder):
	connect_signals(deck_builder);
	deck_builder.random = random;
	deck_builder.deck.init(deck_builder.random);
	deck_builder.Server.load_cards(deck_builder);
	deck_builder.active = true;

static func connect_signals(deck_builder : NexusDeckBuilder):
	for signal_ in ["empty_slot", "switch_slot"]:
		deck_builder.deck.connect(signal_, deck_builder, signal_);
