extends Nexus

const Init : GDScript = preload("res://Scripts/Scenes/Nexus/Init.gd");
const PageLoader : GDScript = preload("res://Scripts/Scenes/Nexus/PageLoader.gd");

func _ready():
	save_deck(System.Decklist.load());

func open_page(page_name : String):
	PageLoader.open_page(page_name, self);

func save_deck(deck_data : Array):
	decklist = deck_data;

func enter_game():
	if !active or decklist.size() < 12:
		return;
	emit_signal("enter_game", decklist);

func highlight(card : GameplayCard):
	set_active(false);
	highlighter.eat(card);

func highlighter_closed():
	activate();
