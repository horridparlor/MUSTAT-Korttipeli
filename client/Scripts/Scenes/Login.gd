extends Login

const Accounts : GDScript = preload("res://Scripts/Scenes/Login/Accounts.gd");
const Server : GDScript = preload("res://Scripts/Scenes/Login/Server.gd");

func init(message : String, random_ : RandomNumberGenerator):
	Server.load_accounts(self);
	if message != "Default":
		set_title(message);
	set_random(random_);
	active = true;

func set_random(random_ : RandomNumberGenerator):
	random = random_;
	deck_builder.init(random);
	deck_builder.connect("deck_submitted", self, "enter_game");

func _on_http_response(id : String, data : Array):
	match id:
		"accounts_loaded":
			for account in data:
				System.Convert.numerice(account, [1]);
				var account_id : int = account[0];
				if account_id < 0:
					continue;
				Accounts.instance(account_id, account[1], self);

func account_chosen(id : int):
	if !active:
		return;
	open_deck_builder(id);
	active = false;

func enter_game(id : int, card_ids : Array):
	emit_signal("account_chosen", id, card_ids);

func open_deck_builder(id : int):
	deck_builder.eat(id);
