const PATH : String = "login/";

static func load_accounts(login : Login):
	System.Server.request(get_request_path("get_accounts"), login, "accounts_loaded");

static func get_request_path(id : String):
	var request_path : String;
	match id:
		"get_accounts":
			request_path = "get_accounts.php";
	return PATH + request_path;
