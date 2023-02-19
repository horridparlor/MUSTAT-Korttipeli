const DOMAIN : String = "https://mustat.fi/";
const PATH : String = DOMAIN + "dev-server/";

static func parse_response(body : PoolByteArray):
	return JSON.parse(body.get_string_from_utf8()).result;

static func request(request_path : String, parent : Node, response_id : String, leave_raw : bool = false, do_timeout : bool = false):
	var http : HTTPRequest = OneTimeRequest.new();
	http.init(PATH + request_path, parent, response_id, leave_raw, do_timeout);

static func rapidcall(requests : Dictionary, parent : Node):
	for key in requests:
		request(requests[key], parent, key);

static func ids(parent : Node2D, own : bool = true):
	var player_id : int = parent.player_id;
	if !own:
		player_id = parent.enemy_id;
	return ".php?game_id=%d&player_id=%d" % [parent.game_id, player_id];
