extends LoginDeckBuilder

const CardMovement : GDScript = preload("res://Scripts/Login/DeckBuilder/CardMovement.gd");
const Core : GDScript = preload("res://Scripts/Login/DeckBuilder/Core.gd");
const Response : GDScript = preload("res://Scripts/Login/DeckBuilder/Response.gd");
const Server : GDScript = preload("res://Scripts/Login/DeckBuilder/Server.gd");

func init(random_ : RandomNumberGenerator):
	random = random_;
	Server.load_cards(self);
	connect_highlighter();

func connect_highlighter():
	highlighter.init(random);
	highlighter.connect("close", self, "highlighter_closed");

func eat(id : int):
	login_id = id;
	visible = true;
	active = true;

func hide():
	visible = false;
	
func _on_http_response(id : String, data : Array):
	Response.route(id, data, self);

func card_focused(card : GameplayCard):
	if !active:
		return;
	elif focused_card != null:
		return;
	card.start_moving();
	card.active = true;
	focused_card = card;

func card_unfocused(card : GameplayCard):
	card.stop_moving();
	CardMovement.move_around(card, self);
	focused_card = null;

func highlight_card(card : GameplayCard):
	active = false;
	highlighter.eat(card);
	CardMovement.move_around(card, self);

func highlighter_closed():
	active = true;

func toggle_play_button():
	play_button.visible = enemy_cards.size() == 12;

func _on_SubmitDeck_pressed():
	emit_signal("deck_submitted", login_id, CardMovement.convert_decklist(self));
