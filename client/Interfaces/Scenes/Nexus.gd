extends Node2D
class_name Nexus

signal enter_game(decklist);

onready var highlighter : GameplayHighlighter = $Highlighter;
onready var page_loader : NexusPageLoader = $PageLoader;
onready var page_layer : Node2D = $Pages;

var activation_timer : Timer;
var active : bool;
var active_page : NexusContentPage;
var decklist : Array;
var random : RandomNumberGenerator;

func _ready():
	activation_timer = System.Instance.instant_timer("activated", self);

func activate():
	activation_timer.start();

func activated():
	activation_timer.stop();
	set_active(true);
	if active_page != null:
		active_page.highlighter_closed(true);

func set_active(boolean : bool):
	active = boolean;
	page_loader.active = boolean;
