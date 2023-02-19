static func update_attack_animations(data : Array, gameplay : Gameplay):
	if System.Test.data_collapses(data):
		return;
	for attack in data:
		route_attack_animation(attack, gameplay);

static func route_attack_animation(attack : Array, gameplay : Gameplay):
	System.Convert.numerice(attack);
	for enemy_card in gameplay.enemy_cards:
		if enemy_card.card_id == attack[0]:
			for own_card in gameplay.own_cards:
				if own_card.card_id == attack[1]:
					load_attack_animation(enemy_card, own_card);
					break;
			return;
					
static func load_attack_animation(attacker : GameplayCard, target : GameplayCard):
	attacker.go_to_positions.append(target.position);
	if System.Vectors.is_default(attacker.go_to_positions[0]):
		attacker.go_to_positions.remove(0);
