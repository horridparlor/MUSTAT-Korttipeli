extends Node2D
class_name NexusPageLoader

signal open_page(page_name);

onready var deck_builder : NexusPageButton = $DeckBuilder;
onready var game_center : NexusPageButton = $GameCenter;
onready var trade_center : NexusPageButton = $TradeCenter;

var active : bool;
var active_button : NexusPageButton;

func get_buttons():
	return [deck_builder, game_center, trade_center];

func get_button_names():
	return ["Deck Builder", "Game Center", "Variant Shop"];
