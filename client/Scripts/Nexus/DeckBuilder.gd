extends NexusDeckBuilder

const CardMovement : GDScript = preload("res://Scripts/Nexus/DeckBuilder/CardMovement.gd");
const Core : GDScript = preload("res://Scripts/Nexus/DeckBuilder/Core.gd");
const Init : GDScript = preload("res://Scripts/Nexus/DeckBuilder/Init.gd");
const Response : GDScript = preload("res://Scripts/Nexus/DeckBuilder/Response.gd");
const Server : GDScript = preload("res://Scripts/Nexus/DeckBuilder/Server.gd");
const Slide : GDScript = preload("res://Scripts/Nexus/DeckBuilder/Slide.gd");

func init(random_ : RandomNumberGenerator):
	Init.init(random_, self);

func _on_http_response(id : String, data : Array):
	Response.route(id, data, self);

func card_focused(card : GameplayCard):
	if !active or card_not_in_view(card):
		return;
	card.start_moving();

func card_not_in_view(card : Card):
	return !System.Physics.Collision.collides(card, collection) and !card in deck_storage;

func quick_click(card : GameplayCard):
	if !active or abs(to_slide) > SLIDE_PICKING_FLOOR:
		return;
	CardMovement.move_around(card, self, true);

func long_click(card : GameplayCard):
	if !active:
		return;
	active = false;
	emit_signal("highlight", card);

func _on_Collection_slide_collection(boolean : bool = true):
	is_sliding = boolean;
	if is_sliding:
		sliding_position = get_global_mouse_position().y;

func _physics_process(delta : float):
	var mouse_position : Vector2 = get_global_mouse_position();
	if is_sliding:
		to_slide += (mouse_position.y - sliding_position) * SLIDING_FRICTION;
		sliding_position = mouse_position.y;
	if to_slide == 0:
		return;
	Slide.slide_collection(mouse_position, delta, self);

func empty_slot(slot_index : int):
	if slot_index != active_deck_slot:
		return;
	CardMovement.empty_deck(self);

func switch_slot(slot_index : int):
	active_deck_slot = slot_index;
	CardMovement.load_decklist(active_deck_slot, self);
	System.Decklist.store_active_slot(active_deck_slot);
