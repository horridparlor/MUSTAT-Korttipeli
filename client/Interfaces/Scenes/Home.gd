extends Node2D
class_name Home

onready var camera : Camera2D = $Camera;
onready var auth_timer : Timer = $Timers/AuthTimer;

var decklist : Array;
var gameplay : Gameplay;
var nexus : Nexus;
var game_id : int;
var player_id : int;
var password : int;
var random : RandomNumberGenerator = RandomNumberGenerator.new();
var current_page : String;
