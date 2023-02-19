extends CardHolder
class_name Gameplay

signal log_out
signal game_named

onready var activation_timer : Timer = $Timers/Activation;
onready var deck : GameplayDeck = $Own/Deck;
onready var end_messages : Node2D = $EndMessages;
onready var enemy_deck : GameplayEnemyDeck = $Enemy/EnemyDeck;
onready var enemy_field : GameplayEnemyField = $Enemy/EnemyField;
onready var enemy_grave : GameplayEnemyGrave = $Enemy/EnemyGrave;
onready var enemy_hand : GameplayEnemyHand = $Enemy/EnemyHand;
onready var enemy_wait_timer : Timer = $Timers/EnemyWait;
onready var field : GameplayField = $Own/Field;
onready var grave : GameplayGrave = $Own/Grave;
onready var hand : GameplayHand = $Own/Hand;
onready var log_out : GameplayLogOut = $UI/LogOut;
onready var mana_bar : GameplayManaBar = $ManaBar;
onready var sound_player : AudioStreamPlayer = $Audio/SoundPlayer;
onready var turn_passer : GameplayTurnPasser = $UI/TurnPasser;

var active : bool;
var cards_to_move : Array;
var decklist : Array;
var end_message : GameplayEndMessage;
var enemy_id : int;
var game_ended : bool;
var game_id : int;
var is_moving_card : bool;
var locked_enemy : GameplayCard;
var mana_left : int;
var password : int;
var starting_player : int;
var turn_number : int;
var waiting_lobby : GameplayWaitingLobby;
