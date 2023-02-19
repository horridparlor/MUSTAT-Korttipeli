static func card_focused(card : GameplayCard, gameplay : Gameplay):
	if gameplay.focused_card == null:
		if card.active:
			gameplay.focused_card = card;
		card.start_moving();

static func card_unfocused(card : GameplayCard, gameplay : Gameplay):
	var switched_zones : bool;
	if gameplay.focused_card == card:
		if card_played(card, gameplay) or \
		card_returned_hand(card, gameplay) or \
		card_attacked(card, gameplay):
			switched_zones = true;
		gameplay.focused_card = null;
		card.stop_moving(switched_zones);

static func card_played(card : GameplayCard, gameplay : Gameplay):
	if can_be_played(card, gameplay):
		gameplay.field.play_card(card, gameplay);
		return true;
	return false;

static func can_be_played(card : GameplayCard, gameplay : Gameplay):
	var field : GameplayField = gameplay.field;
	return card.location == "Hand" and field.room_left() and \
	gameplay.mana_left >= card.get_cost() and collides(card, field);

static func card_returned_hand(card : GameplayCard, gameplay : Gameplay):
	if can_return_hand(card, gameplay):
		gameplay.hand.return_card(card, gameplay);
		return true;
	return false;

static func can_return_hand(card : GameplayCard, gameplay : Gameplay):
	var hand : GameplayHand = gameplay.hand;
	return card.location == "Field" and gameplay.hand.room_left() and \
	collides(card, hand);

static func collides(card : GameplayCard, zone : GameplayZone):
	return System.Physics.Collision.collides(card, zone);

static func card_attacked(card : GameplayCard, gameplay : Gameplay):
	if gameplay.locked_enemy != null:
		gameplay.Server.commit_attack(card, gameplay);
		return true;
	return false;
