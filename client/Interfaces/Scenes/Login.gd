extends Node2D
class_name Login

signal account_chosen(id, card_ids);

onready var accounts_layer : Node2D = $Accounts;
onready var deck_builder : LoginDeckBuilder = $DeckBuilder;
onready var title : Label = $Title;

var accounts : Array;
var active : bool;
var random : RandomNumberGenerator;

func set_title(message : String):
	title.text = message;
