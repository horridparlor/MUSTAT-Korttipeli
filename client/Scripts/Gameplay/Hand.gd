extends GameplayHand

func _ready():
	room_for_cards = 5;

func return_card(card : GameplayCard, gameplay : Gameplay):
	move_card(card, gameplay);
	gameplay.Mana.refund(card, gameplay);

func move_card(card : GameplayCard, gameplay : Gameplay):
	System.Zones.move_card(card, ZONE_NAME, gameplay);

func draw_cards(amount : int, gameplay : Gameplay):
	var card : GameplayCard;
	for i in range(amount):
		if !room_left() or gameplay.deck.count_cards() < i:
			break;
		card = gameplay.deck.select_card(i);
		move_card(card, gameplay);
