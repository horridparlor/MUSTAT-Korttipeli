extends CardHolder
class_name LoginDeckBuilder

signal deck_submitted(login_id, card_ids);

onready var play_button : Node2D = $PlayButton;

var active : bool;
var login_id : int;
