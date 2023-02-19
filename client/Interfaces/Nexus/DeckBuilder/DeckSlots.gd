extends Node2D
class_name NexusDeckBuilderDeckSlots

signal empty_slot(slot_index);
signal switch_slot(slot_index);

onready var slot_1 : NexusPageButton = $Slot1;
onready var slot_2 : NexusPageButton = $Slot2;
onready var slot_3 : NexusPageButton = $Slot3;
onready var slot_4 : NexusPageButton = $Slot4;
onready var slot_5 : NexusPageButton = $Slot5;

var active_slot : NexusPageButton;

func get_slots():
	return [slot_1, slot_2, slot_3, slot_4, slot_5];
