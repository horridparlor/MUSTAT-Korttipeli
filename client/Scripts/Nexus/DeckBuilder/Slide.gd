const REVEAL_MORE_MARGIN : int = 100;

static func slide_collection(mouse_position : Vector2, delta : float, deck_builder : NexusDeckBuilder):
	var slide : float = deck_builder.to_slide * deck_builder.SLIDING_SPEED * delta;
	if cards_layer_at_limit(slide, deck_builder) or abs(deck_builder.to_slide) - abs(slide) < deck_builder.SLIDING_FLOOR:
		deck_builder.to_slide = 0;
	deck_builder.to_slide -= slide;

static func cards_layer_at_limit(slide : float, deck_builder : NexusDeckBuilder):
	var max_slide : float = -max_collection_slide(deck_builder);
	var new_position : int = deck_builder.cards.position.y + slide;
	if new_position + REVEAL_MORE_MARGIN > 0 and can_return_front_collection(deck_builder):
		return false;
	elif new_position - REVEAL_MORE_MARGIN < max_slide and can_return_back_collection(deck_builder):
		return false;
	deck_builder.cards.position.y = System.Scale.floats(new_position, max_slide, 0);
	return deck_builder.cards.position.y in [max_slide, 0];

static func can_return_back_collection(deck_builder : NexusDeckBuilder):
	var card_identifier : Array;
	for i in range(6):
		if deck_builder.cards_back_collection.size() == 0:
			if i == 0:
				return false;
			break;
		card_identifier = deck_builder.cards_back_collection[deck_builder.cards_back_collection.size() - 1];
		deck_builder.cards_back_collection.erase(card_identifier);
		deck_builder.Core.hide_front(deck_builder);
		deck_builder.Core.instance_card(card_identifier, deck_builder);
		deck_builder.CardMovement.reorder(deck_builder);
	deck_builder.to_slide += height_margin(deck_builder);
	return true;

static func can_return_front_collection(deck_builder : NexusDeckBuilder):
	var card_identifier : Array;
	for i in range(6):
		if deck_builder.cards_front_collection.size() == 0:
			if i == 0:
				return false;
			break;
		card_identifier = deck_builder.cards_front_collection[0];
		deck_builder.cards_front_collection.erase(card_identifier);
		deck_builder.Core.hide_back(deck_builder);
		deck_builder.Core.instance_card(card_identifier, deck_builder);
		deck_builder.CardMovement.reorder(deck_builder);
	deck_builder.to_slide -= height_margin(deck_builder);
	return true;

static func max_collection_slide(deck_builder : NexusDeckBuilder):
	var card_y_space : float = height_margin(deck_builder);
	return (deck_builder.card_storage.size() - 13) / 6 * card_y_space;

static func height_margin(deck_builder : NexusDeckBuilder):
	return deck_builder.CardMovement.COLLECTION_HEIGHT_MARGIN;
