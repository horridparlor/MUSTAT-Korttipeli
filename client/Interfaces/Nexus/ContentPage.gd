extends Node2D
class_name NexusContentPage

signal highlight(card);

onready var cards : Node2D = $Cards;

var activation_timer : Timer;
var active : bool;
var card_storage : Array;
var random : RandomNumberGenerator;

func _ready():
	activation_timer = System.Instance.instant_timer("activate", self);

func pop():
	queue_free();

func highlighter_closed(is_instant : bool = false):
	if is_instant:
		activate();
		return;
	activation_timer.start();

func activate():
	activation_timer.stop();
	active = true;
