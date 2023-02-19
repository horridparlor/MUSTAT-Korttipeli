const PATH = "cards/";

static func request(request_id : String, response_id : String, card : Card):
	var leave_raw : bool = request_id in ["load_sound", "load_variant"];
	var timeout : float = 0;
	match request_id:
		"base_stats":
			timeout = 0.4;
		"load_variant":
			timeout = 2.0;
	System.Server.request(route_request_path(request_id, card), card, response_id, leave_raw, timeout);

static func route_request_path(id : String, card : Card, scale : int = 1):
	var request_path : String;
	var short_ids : String = ".php?base_id=" + str(card.base_id);
	var ids : String = short_ids + "&variant_id=" + str(card.variant_id);
	match id:
		"base_stats":
			request_path = "base_stats" + short_ids;
		"load_sound":
			request_path = "load_sound" + ids + "&zone=" + System.Cards.Sound.normalized_location(card);
		"load_variant":
			request_path = "load_variant" + ids + \
			"&scale=" + str(scale);
	return PATH + request_path;

static func load_variant(card : GameplayCard, force_redownload : bool = false):
	if !System.Cards.Variants.needs_download(card, force_redownload):
		return;
	card.Core.start_downloading_variant(card);

static func download_variant(card : GameplayCard):
	request("load_variant", "variant_loaded", card);

static func load_sound(card : Card):
	request("load_sound", System.Cards.Sound.normalized_location(card) + "_sound_loaded", card);

static func load_base_stats(card : GameplayCard):
	request("base_stats", "base_stats_loaded", card);
