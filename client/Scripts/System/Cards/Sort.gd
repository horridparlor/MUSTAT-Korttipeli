static func order(collection : Array):
	var index : int = 1;
	collection.sort_custom(System.Cards.Sort, "by_cost");
	for card in collection:
		card.card_slot = index;
		index += 1;

static func by_cost(card_a : GameplayCard, card_b : GameplayCard):
	var costs : Array = [card_a.base_cost, card_b.base_cost];
	if costs[0] != costs[1]:
		return costs[0] < costs[1];
	return by_power(card_a, card_b);

static func by_power(card_a : GameplayCard, card_b : GameplayCard):
	var powers : Array = [card_a.base_power, card_b.base_power];
	if powers[0] != powers[1]:
		return powers[0] < powers[1];
	return by_name(card_a, card_b);

static func by_name(card_a : GameplayCard, card_b : GameplayCard):
	return card_a.base_name < card_b.base_name;
