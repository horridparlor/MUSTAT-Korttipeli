extends NexusPageLoader

func init(random : RandomNumberGenerator):
	connect_buttons(random);
	activate_button(game_center);

func connect_buttons(random : RandomNumberGenerator):
	var button_names : Array = get_button_names();
	var name_index : int;
	for button in get_buttons():
		button.init(random, button_names[name_index]);
		name_index += 1;
		connect_signals(button);

func connect_signals(button : NexusPageButton):
	button.connect("activate", self, "activate_button");

func activate_button(button : NexusPageButton):
	if !active or button == active_button:
		return;
	elif active_button != null:
		active_button.deactivate();
	button.activate();
	active_button = button;
	emit_signal("open_page", convert_page_name(button));

func convert_page_name(button : NexusPageButton):
	return button.button_name.replace(" ", "");
