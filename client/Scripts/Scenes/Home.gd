extends Home

const Core : GDScript = preload("res://Scripts/Scenes/Home/Core.gd");
const Init : GDScript = preload("res://Scripts/Scenes/Home/Init.gd");
const PageLoader : GDScript = preload("res://Scripts/Scenes/Home/PageLoader.gd");
const Response : GDScript = preload("res://Scripts/Scenes/Home/Response.gd");
const Server : GDScript = preload("res://Scripts/Scenes/Home/Server.gd");

func _ready():
	Init.start(self);

func enter_game(decklist : Array):
	PageLoader.enter_game(player_id, decklist, self);

func _on_http_response(id : String, data : Array):
	Response.route(id, data, self);

func _on_AuthTimer_timeout():
	auth_timer.stop();
	Server.authenticate(self);
	
func log_out():
	PageLoader.logged_out(self, "You logged out.");
	
func game_named():
	game_id = gameplay.game_id;
