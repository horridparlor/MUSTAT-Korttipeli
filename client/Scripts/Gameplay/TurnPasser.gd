extends GameplayTurnPasser

func _on_PassTurn_pressed():
	if !passed:
		emit_signal("pass_turn");

func eat_state(data : Array):
	System.Convert.numerice(data);
	if data.size() == 0:
		return
	elif data[0] == 1:
		passed();
	else:
		release();

func eat_update(data : Array):
	update_turn_number(data[0]);
	true_charge = data[1];

func update_turn_number(turn_number : int):
	current_turn = turn_number;
	if current_turn > final_turn:
		end_game();
	update_label();

func end_game():
	game_ended = true;
	load_panel.visible = false;
	set_label("GAME ENDED");
	emit_signal("game_ended");

func passed():
	passed = true;
	update_label();

func release():
	passed = false;
	update_label();

func update_label():
	var prefix : String = "Pass turn";
	var subfix : String = str(current_turn) + "/" + str(final_turn);
	if game_ended:
		return;
	elif passed:
		prefix = "Passed";
	if current_turn == final_turn:
		subfix = "FINAL";
	set_label(prefix + "\n(" + subfix + ")");

func set_label(message : String):
	label.text = message;

func update_load():
	load_panel.rect_size.x = min(8.2 * load_charge, MAX_CHARGE) + MIN_CHARGE;

func _physics_process(delta):
	load_charge += (true_charge - load_charge) * delta;
	update_load()
