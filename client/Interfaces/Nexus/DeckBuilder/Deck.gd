extends Node
class_name NexusDeckBuilderDeck

signal empty_slot(slot_index);
signal switch_slot(slot_index);

onready var deck_slots : NexusDeckBuilderDeckSlots = $DeckSlots;
