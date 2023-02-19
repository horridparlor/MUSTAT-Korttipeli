class_name CardIndicator

var player_id : int;
var card_id : int;
var base_id : int;
var variant_id : int;
var location : String;
var cost_change : int;
var power_change : int;
var attacks : int;

func _init(_player_id : int, _card_id : int, base : int, variant : int, _location : String, \
cost : int = 0, power : int = 0, attack : int = 0):
	player_id = _player_id;
	card_id = _card_id;
	base_id = base;
	variant_id = variant;
	location = System.Convert.namelize(_location);
	cost_change = cost;
	power_change = power;
	attacks = attack;

func _to_string():
	return "player_id = %d; card_id = %d; base_id = %d; variant_id = %d; location = %s; cost_change = %d; power_change = %d; attacks = %d" \
	% [player_id, card_id, base_id, variant_id, location, cost_change, power_change, attacks];
