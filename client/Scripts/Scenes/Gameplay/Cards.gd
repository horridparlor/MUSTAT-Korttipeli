const AttackAnimations : GDScript = preload("res://Scripts/Scenes/Gameplay/Cards/AttackAnimations.gd");

const ATTACK_DETECTION_RANGE : Vector2 = Vector2(25, 175);
const ATTACK_TARGET_MOTION_PATH : String = "res://Particles/Effects/Cards/AttackTargetMotion2Layer.tscn";

static func update_cards(data : Array, gameplay : Gameplay):
	update_card_zones(data[0], gameplay);
	AttackAnimations.update_attack_animations(data[1], gameplay);
	gameplay.GameState.update_game_status(data[2], gameplay);

static func update_card_zones(data : Array, gameplay : Gameplay):
	var indicator : CardIndicator;
	if System.Test.data_collapses(data):
		return;
	for raw_values in data:
		indicator = System.Cards.parse_indicator(raw_values);
		route_indicator(indicator, gameplay);

static func route_indicator(indicator : CardIndicator, gameplay : Gameplay):
	var player_id : int = indicator.player_id;
	var card_id : int = indicator.card_id;
	var storage : Array = System.Cards.get_storage(player_id, gameplay);
	var other_storage : Array = System.Cards.get_storage(player_id, gameplay, false)
	for card in storage:
		if card.card_id == card_id:
			card.eat_indicator(indicator, gameplay);
			return;
	if !indicator.location in ["Deck", "Grave"]:
		for card in other_storage:
			if card.card_id == card_id:
				other_storage.erase(card);
				storage.append(card);
				System.Zones.move_card_to_opponent(player_id, card, gameplay);
				return;
		spawn_card(indicator, gameplay);
		
static func spawn_card(indicator : CardIndicator, gameplay : Gameplay):
	var card : GameplayCard = System.Instance.card(indicator, gameplay);
	card.visible = false;

static func detect_attack(gameplay : Gameplay):
	for enemy in gameplay.enemy_field.cards:
		if System.Physics.Collision.collides(gameplay.focused_card, enemy, ATTACK_DETECTION_RANGE):
			lock_attack(enemy, gameplay);
			return;
	lose_enemy(gameplay);

static func lock_attack(card : GameplayCard, gameplay : Gameplay):
	if card != gameplay.locked_enemy:
		lose_enemy(gameplay);
	gameplay.locked_enemy = card;
	card.animations.toggle_motion(true, ATTACK_TARGET_MOTION_PATH);

static func lose_enemy(gameplay : Gameplay):
	var locked_enemy : GameplayCard = gameplay.locked_enemy;
	if locked_enemy != null:
		locked_enemy.animations.toggle_motion(false);
	gameplay.locked_enemy = null;
