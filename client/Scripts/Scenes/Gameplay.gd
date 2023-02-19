extends Gameplay

const CardMovement : GDScript = preload("res://Scripts/Scenes/Gameplay/CardMovement.gd");
const Cards : GDScript = preload("res://Scripts/Scenes/Gameplay/Cards.gd");
const Core : GDScript = preload("res://Scripts/Scenes/Gameplay/Core.gd");
const GameState : GDScript = preload("res://Scripts/Scenes/Gameplay/GameState.gd");
const Highlighter : GDScript = preload("res://Scripts/Scenes/Gameplay/Highlighter.gd");
const Init : GDScript = preload("res://Scripts/Scenes/Gameplay/Init.gd");
const Mana : GDScript = preload("res://Scripts/Scenes/Gameplay/Mana.gd");
const Response : GDScript = preload("res://Scripts/Scenes/Gameplay/Response.gd");
const Server : GDScript = preload("res://Scripts/Scenes/Gameplay/Server.gd");

func _on_http_response(id : String, data : Array):
	Response.route(id, data, self);

func card_focused(card : GameplayCard):
	if !is_active():
		return;
	CardMovement.card_focused(card, self);

func card_unfocused(card : GameplayCard):
	if !is_active():
		return;
	CardMovement.card_unfocused(card, self);
	Cards.lose_enemy(self);

func quick_click(card : GameplayCard):
	Highlighter.highlight(card, self);

func close_highlighter():
	Highlighter.close(self);

func turn_passed():
	if !is_active():
		return;
	turn_passer.passed();
	Server.pass_turn(self);

func _on_Activation_timeout():
	activation_timer.stop();
	active = true;

func _on_EnemyWait_timeout():
	enemy_wait_timer.stop();
	Server.load_game(self);

func return_home():
	if active or game_ended or waiting_lobby != null:
		emit_signal("log_out");

func _physics_process(delta):
	if focused_card != null and focused_card.location == "Field":
		Cards.detect_attack(self);

func is_active():
	return active and !game_ended;

func game_ended():
	if game_ended:
		return;
	game_ended = true;
	if highlighter.visible:
		close_highlighter();
	active = false;
	Server.get_winner(self);

func sound_loaded(location : String, data : PoolByteArray, do_store : bool, card : Card):
	System.Cards.Sound.play(location, card, data, sound_player, do_store);

func card_popped(card : GameplayCard):
	System.Zones.route_zone(card.location, self).pull_card(card);
	own_cards.erase(card);
	enemy_cards.erase(card);
	card.queue_free();
