extends GlowNode
class_name GameplayTurnPasser

signal game_ended
signal pass_turn

onready var label : Label = $Label;
onready var load_panel : Panel = $Load;

const MAX_CHARGE : int = 300;
const MIN_CHARGE : int = 94;

var current_turn : int;
var final_turn : int = 6;
var game_ended : bool;
var load_charge : float;
var passed : bool;
var true_charge : int;
