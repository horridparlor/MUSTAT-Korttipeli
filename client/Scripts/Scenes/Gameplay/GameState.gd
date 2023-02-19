static func load_game(data : Array, gameplay : Gameplay):
	if System.Test.data_collapses(data):
		gameplay.Core.wait_for_opponent(data[0], gameplay);
		return;
	data = System.Convert.numerice(data[0]);
	gameplay.Core.update_id(data[0], gameplay);
	gameplay.enemy_id = data[1];
	gameplay.starting_player = data[2];
	gameplay.turn_number = data[3];
	load_game_state(gameplay);

static func load_game_state(gameplay : Gameplay):
	gameplay.Server.pass_turn(gameplay, false);
	gameplay.Core.activate(gameplay);

static func instance_cards(data : Array, zone_name : String, gameplay : Gameplay):
	var indicator : CardIndicator;
	if System.Test.data_collapses(data):
		return;
	for raw_values in data:
		indicator = System.Cards.parse_indicator(raw_values);
		System.Zones.move_card(System.Instance.card(indicator, gameplay), \
		zone_name, gameplay);

static func update_game_status(data : Array, gameplay : Gameplay):
	if System.Test.data_collapses(data):
		return;
	data = System.Convert.numerice(data[0]);
	gameplay.turn_passer.eat_update(data);
	gameplay.Mana.eat(data[2], gameplay);
