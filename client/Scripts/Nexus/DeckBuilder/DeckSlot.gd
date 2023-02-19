extends NexusDeckBuilderSlot

func init(random : RandomNumberGenerator, index : int):
	activate_animations(random);
	slot_index = index;
	label.text = "Slot " + str(slot_index);

func _on_Activate_pressed():
	press();
	long_press_timer.start();

func _on_Activate_released():
	long_press_timer.stop();

func long_press():
	long_press_timer.stop();
	emit_signal("long_press", self);
