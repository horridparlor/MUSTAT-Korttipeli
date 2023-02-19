const PLAY_MOTION_PATH : String = "res://Particles/Effects/Cards/PlayMotion2Layer.tscn";

static func pay(amount : int, gameplay : Gameplay):
	change(-amount, gameplay);

static func change(amount : int, gameplay : Gameplay):
	gameplay.mana_left += amount;
	update_count(gameplay);

static func update_count(gameplay : Gameplay):
	gameplay.mana_bar.update_count(gameplay);

static func refund(card : GameplayCard, gameplay : Gameplay):
	change(card.get_cost(), gameplay);

static func eat(value : int, gameplay : Gameplay):
	gameplay.mana_left = int(value);
	update_count(gameplay);
	activate_motion(gameplay);

static func activate_motion(gameplay : Gameplay):
	for card in gameplay.hand.cards:
		card.animations.toggle_motion(can_be_played(card, gameplay), PLAY_MOTION_PATH);

static func can_be_played(card : GameplayCard, gameplay : Gameplay):
	return card.get_cost() <= gameplay.mana_left and gameplay.field.room_left();
