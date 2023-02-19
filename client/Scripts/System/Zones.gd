const DECK_HEIGHT : int = 1200;
const FIELD_MARGIN : int = 90;
const GRAVE_HEIGHT : int = 900;
const GRAVE_MARGIN : int = 900;
const SPAWNING_POINT : Vector2 = Vector2(0, DECK_HEIGHT);

static func move_card(card : GameplayCard, to_name : String, gameplay : Gameplay, finalized : bool = false):
	var from_name : String = card.location;
	var zone_from : GameplayZone = route_zone(from_name, gameplay);
	var zone_to : GameplayZone = route_zone(to_name, gameplay);
	if from_name == to_name or card.moving_zones:
		return;
	elif !finalized and zone_from != null:
		gameplay.Server.move_card(card, to_name, gameplay);
	finalize_movement(card, zone_from, zone_to, gameplay);

static func finalize_movement(card : GameplayCard, zone_from : GameplayZone, zone_to : GameplayZone, gameplay : Gameplay):
	pull_card(card, zone_from, zone_to, gameplay);
	add_card(card, zone_to);
	card.book_zone_movement();

static func route_zone(zone_name : String, gameplay : Gameplay):
	match zone_name:
		"Deck":
			return gameplay.deck;
		"EnemyDeck":
			return gameplay.enemy_deck;
		"EnemyField":
			return gameplay.enemy_field;
		"EnemyGrave":
			return gameplay.enemy_grave;
		"EnemyHand":
			return gameplay.enemy_hand;
		"Field":
			return gameplay.field;
		"Grave":
			return gameplay.grave;
		"Hand":
			return gameplay.hand;
	return null;

static func add_card(card : GameplayCard, zone : GameplayZone):
	zone.cards.append(card);
	card.location = zone.ZONE_NAME;
	zone.add_card(card);
	activate_card(card);

static func activate_card(card : GameplayCard):
	var location : String = System.Cards.Sound.normalized_location(card);
	if ! "Enemy" in card.location:
		card.active = true;
	if location in ["field", "grave"] or card.location == "Hand":
		System.Cards.Sound.load_sound(card);
		card.stop_pop();
	if location in ["deck", "grave"]:
		card.pop();
	else:
		card.stop_pop();
	

static func pull_card(card : GameplayCard, zone_from : GameplayZone, zone_to : GameplayZone, gameplay : Gameplay):
	if zone_from == null:
		route_starting_position(card, zone_to, gameplay);
	else:
		zone_from.pull_card(card);

static func route_starting_position(card : GameplayCard, zone : GameplayZone, gameplay : Gameplay):
	var starting_position : Vector2 = SPAWNING_POINT;
	if "Grave" in zone.ZONE_NAME:
		card.do_teleport = true;
	elif card.player_id != gameplay.player_id:
		starting_position *= -1;
	card.position = starting_position;
			
static func reorder(zone : GameplayZone):
	for card in zone.cards:
		card.target_position = route_new_position(zone.ZONE_NAME, card.card_slot, zone.count_cards());
		card.max_slot = zone.count_cards();

static func route_new_position(zone_name : String, card_slot : int, card_count : int):
	var half_margin : int;
	var const_margin : int;
	var height : int;
	match zone_name:
		"Deck":
			height = DECK_HEIGHT;
		"EnemyDeck":
			height = -DECK_HEIGHT;
		"EnemyField":
			half_margin = FIELD_MARGIN;
			height = -260;
		"EnemyGrave":
			const_margin = -GRAVE_MARGIN;
			height = -GRAVE_HEIGHT;
		"EnemyHand":
			height = -DECK_HEIGHT;
		"Field":
			half_margin = FIELD_MARGIN;
			height = 80;
		"Grave":
			const_margin = GRAVE_MARGIN;
			height = GRAVE_HEIGHT;
		"Hand":
			half_margin = 120;
			height = 470;
			if card_count > 4:
				half_margin -= 12.5;
	return new_position(card_slot, card_count, half_margin, const_margin, height);

static func new_position(card_slot : int, card_count : int, half_margin : int, const_margin : int, height : int):
	var margin : int = 2 * half_margin;
	return Vector2(-(card_count + 1) * half_margin + margin * card_slot + const_margin, height);

static func move_card_to_opponent(player_id : int, card : GameplayCard, gameplay : Gameplay):
	var location : String = card.location;
	if player_id == gameplay.player_id:
		location = location.replace("Enemy", "");
	elif !"Enemy" in location:
		location = "Enemy" + location;
	print(location);
	card.player_id = player_id;
	move_card(card, location, gameplay, true);
