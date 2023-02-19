extends GameplayCard

const Core : GDScript = preload("res://Scripts/Cards/GameplayCard/Core.gd");
const Indicators : GDScript = preload("res://Scripts/Cards/GameplayCard/Indicators.gd");
const Move : GDScript = preload("res://Scripts/Cards/GameplayCard/Move.gd");
const Response : GDScript = preload("res://Scripts/Cards/GameplayCard/Response.gd");
const Server : GDScript = preload("res://Scripts/Cards/GameplayCard/Server.gd");

func physics_frame(delta : float):
	var target_pos : Vector2 = target_position;
	if !visible:
		return;
	if is_moving and active:
		Move.towards_mouse(self, delta);
	else:
		if !System.Vectors.is_default(go_to_positions[0]):
			target_pos = go_to_positions[0];
		Move.towards(self, target_pos, delta);
		Move.change_size(self, delta, location in ["Deck", "EnemyDeck", "EnemyHand", "Hand"]);

func _on_MoveButton_pressed():
	release_zone_movement_lock();
	emit_signal("focused", self);

func _on_MoveButton_released():
	long_click_timer.stop();
	if active:
		emit_signal("unfocused", self);
	else:
		stop_moving();

func start_moving():
	is_moving = true;
	quick_click_timer.start();
	long_click_timer.start();

func stop_moving(switched_zones : bool = false):
	is_moving = false;
	if !switched_zones and quick_click_timer.time_left > 0 and \
	!on_quick_click_cooldown:
		emit_signal("quick_click", self);
		quick_click_cooldown();

func quick_click_cooldown():
	on_quick_click_cooldown = true;
	quick_click_cooldown_timer.start();

func _on_OnClickTimer_timeout():
	quick_click_timer.stop();

func _on_QuickClickCooldown_timeout():
	quick_click_cooldown_timer.stop();
	on_quick_click_cooldown = false;

func _on_LongClick_timeout():
	long_click_timer.stop();
	emit_signal("long_click", self);

func eat_indicator(indicator : CardIndicator, gameplay : Gameplay):
	Indicators.eat(indicator, self, gameplay);

func _on_http_response(id : String, data : Array):
	Response.route(id, data, self);

func force_variant_download():
	Server.load_variant(self, true);

func download_variant():
	variant_download_timer.stop();
	Server.download_variant(self);
