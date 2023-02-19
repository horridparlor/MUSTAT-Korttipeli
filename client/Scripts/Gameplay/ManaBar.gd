extends GameplayManaBar

func update_count(gameplay : Gameplay):
	label.text = str(gameplay.mana_left);
