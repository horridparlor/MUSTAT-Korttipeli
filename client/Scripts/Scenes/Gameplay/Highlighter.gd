static func highlight(card : GameplayCard, gameplay : Gameplay):
	gameplay.Core.deactivate(gameplay);
	gameplay.highlighter.eat(card);
	
static func close(gameplay : Gameplay):
	gameplay.Core.activate(gameplay);
