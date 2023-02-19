extends NexusDeckBuilderDeckSlots

func init(random : RandomNumberGenerator):
	var slot_index : int = 1;
	for slot in get_slots():
		slot.init(random, slot_index);
		connect_signals(slot);
		slot_index += 1;
	activate_slot_index(System.Decklist.active_slot());

func connect_signals(slot : NexusPageButton):
	slot.connect("activate", self, "activate_slot");
	slot.connect("long_press", self, "empty_slot");

func activate_slot_index(slot_index : int):
	activate_slot(get_slot(slot_index));

func activate_slot(slot : NexusDeckBuilderSlot):
	if slot == active_slot:
		return
	elif active_slot != null:
		active_slot.deactivate();
	slot.activate();
	active_slot = slot;
	emit_signal("switch_slot", slot.slot_index);

func get_slot(slot_index : int):
	for slot in get_slots():
		if slot.slot_index == slot_index:
			return slot;
	return null;

func empty_slot(slot : NexusDeckBuilderSlot):
	emit_signal("empty_slot", slot.slot_index);
