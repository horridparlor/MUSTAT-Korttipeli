extends Node2D
class_name GameplayZone

var cards : Array;
var room_for_cards : int = -1;

func add_card(card : GameplayCard):
	card.card_slot = count_cards();
	reorder_cards();
	card.visible = true;

func pull_card(card : GameplayCard):
	if !cards.has(card):
		return;
	System.Cards.pull_card(card, cards);
	reorder_cards();

func select_card(index : int = 0):
	if cards.size() > index:
		return cards[index];
	return null;

func reorder_cards():
	System.Zones.reorder(self);

func count_cards():
	return cards.size();

func room_left():
	return room_for_cards == -1 or count_cards() < room_for_cards;

func empty():
	return count_cards() == 0;
