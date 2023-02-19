const BASE_STATS_PATH_PRFIX : String = "user://card_id=";
const BASE_STATS_PATH_SUBFIX : String = ".base_stats";

static func instance(indicator : CardIndicator, card : GameplayCard):
	load_core_stats(indicator, card);
	update_stats(indicator, card);

static func load_core_stats(indicator : CardIndicator, card : GameplayCard):
	for stat in ["player_id", "card_id", "base_id", "variant_id"]:
		card[stat] = indicator[stat];
	get_base_stats(card);
	card.Server.load_variant(card);

static func get_base_stats(card : GameplayCard):
	if load_base_stats(card):
		return;
	card.Server.load_base_stats(card);

static func load_base_stats(card : GameplayCard):
	var file : File = File.new();
	var file_path : String = base_stats_file_path(card);
	var base_stats : Dictionary;
	if !file.file_exists(file_path):
		return false;
	file.open(file_path, file.READ);
	base_stats = file.get_var();
	file.close();
	eat_base_stats(base_stats.data, card);
	return base_stats.session_id == System.session_id;

static func store_base_stats(data : Array, card : GameplayCard):
	var file : File = File.new();
	var base_stats : Dictionary = {
		"session_id" : System.session_id,
		"data" : data
	};
	file.open(base_stats_file_path(card), file.WRITE);
	file.store_var(base_stats);
	file.close();

static func base_stats_file_path(card : GameplayCard):
	return BASE_STATS_PATH_PRFIX + str(card.base_id) + BASE_STATS_PATH_SUBFIX;

static func eat(indicator : CardIndicator, card : GameplayCard, gameplay : Gameplay):
	var location = determine_location(indicator, gameplay);
	update_stats(indicator, card);
	System.Zones.move_card(card, location, gameplay, true);

static func eat_base_stats(data : Array, card : GameplayCard, do_save : bool = false):
	System.Convert.numerice(data, [0, 3]);
	card.base_name = data[0];
	card.base_cost = data[1];
	card.base_power = data[2];
	card.effects_text = data[3];
	if do_save:
		store_base_stats(data, card);
	card.Core.update_visuals(card);

static func update_stats(indicator : CardIndicator, card : GameplayCard):
	for stat in ["player_id", "card_id", "cost_change", "power_change", "attacks"]:
		card[stat] = indicator[stat];
	card.Core.update_visuals(card);

static func determine_location(indicator : CardIndicator, gameplay : Gameplay):
	var is_own : bool = indicator.player_id == gameplay.player_id;
	var location = indicator.location;
	if is_own:
		return location;
	return "Enemy" + location;

static func get_identifier(card : GameplayCard):
	return [card.base_id, card.variant_id];
