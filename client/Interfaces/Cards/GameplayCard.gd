extends Card
class_name GameplayCard

signal focused(_self);
signal unfocused(_self);
signal long_click(_self);
signal pop(_self);
signal quick_click(_self);
signal sound_loaded(location, sound_data, do_store, self_);

onready var animations : CardAnimations = $Animations;
onready var long_click_timer : Timer = $Timers/LongClick;
onready var quick_click_timer : Timer = $Timers/QuickClick;
onready var quick_click_cooldown_timer : Timer = $Timers/QuickClickCooldown;
onready var zone_movement_timer : Timer;

const SIZE : Vector2 = Vector2(140, 210);
const ZONE_MOVEMENT_TIME : float = 1.28;

var active : bool;
var attacks : int;
var base_cost : int;
var base_name : String;
var base_power : int;
var card_id : int;
var card_slot : int;
var cost_change : int;
var do_teleport : bool;
var effects_text : String;
var go_to_positions : Array = [System.Vectors.default()];
var is_moving : bool;
var max_slot : int;
var moving_zones : bool;
var on_quick_click_cooldown : bool;
var player_id : int;
var point_teleport : bool;
var pop_timer : Timer = System.Instance.timer(1, "do_pop", self);
var power_change : int;
var target_position : Vector2;
var variant_download_timer : Timer;

func _ready():
	variant_download_timer = System.Instance.instant_timer("download_variant", self);
	zone_movement_timer = System.Instance.timer(ZONE_MOVEMENT_TIME, "release_zone_movement_lock", self);

func get_cost():
	return base_cost + cost_change;

func get_power():
	return base_power + power_change;

func book_zone_movement():
	moving_zones = true;
	zone_movement_timer.start();

func release_zone_movement_lock():
	moving_zones = false;

func teleport():
	position = Vector2(2 * System.Window);
	do_teleport = true;
	point_teleport = true

func stop_teleport():
	do_teleport = false;
	point_teleport = false;

func pop():
	pop_timer.start();

func do_pop():
	emit_signal("pop", self);

func stop_pop():
	pop_timer.stop();

func download_variant():
	variant_download_timer.stop();
