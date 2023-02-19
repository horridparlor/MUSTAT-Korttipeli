extends Node2D
class_name CardHolder

onready var cards : Node2D = $Cards;
onready var highlighter : GameplayHighlighter = $Highlighter;

var enemy_cards : Array;
var focused_card : GameplayCard;
var own_cards : Array;
var player_id : int = -1;
var random : RandomNumberGenerator = RandomNumberGenerator.new();
