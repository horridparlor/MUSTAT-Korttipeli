extends NexusDeckBuilderDeck

func init(random : RandomNumberGenerator):
	for signal_ in ["empty_slot", "switch_slot"]:
		deck_slots.connect(signal_, self, signal_);
	deck_slots.init(random);

func switch_slot(slot_index : int):
	emit_signal("switch_slot", slot_index);

func empty_slot(slot_index : int):
	emit_signal("empty_slot", slot_index);
