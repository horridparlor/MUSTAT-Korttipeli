extends NexusPageButton

func init(random : RandomNumberGenerator, name_ : String):
	activate_animations(random);
	button_name = name_;
	label.text = button_name;

func _on_Activate_pressed():
	press();
