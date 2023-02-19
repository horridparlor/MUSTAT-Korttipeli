extends GameplayField

func _ready():
	room_for_cards = 6;

func play_card(card : GameplayCard, gameplay : Gameplay):
	System.Zones.move_card(card, ZONE_NAME, gameplay);
	gameplay.Mana.pay(card.get_cost(), gameplay);
