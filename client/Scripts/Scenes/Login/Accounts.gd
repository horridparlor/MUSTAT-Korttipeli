extends Node

const ACCOUNT_PATH : String = "res://Prefabs/Login/Account.tscn";

static func instance(account_id : int, account_name : String, login : Login):
	var account : LoginAccount = System.Instance.load_child(ACCOUNT_PATH, login.accounts_layer);
	login.accounts.append(account);
	account.position = account_position(account, login);
	account.id = account_id;
	account.set_name(account_name);
	account.connect("chosen", login, "account_chosen");
	account.activate_animations(login.random);

static func account_position(account : LoginAccount, login : Login):
	var position : Vector2;
	var index : int = login.accounts.size();
	var size : Vector2 = account.SIZE;
	var margin : int = (System.Window.x - 2 * size.x) / 3;
	var x_direction : int = -1;
	var row : int = (index + 1) / 2;
	if index % 2 == 0:
		x_direction = 1;
	position.x = (size.x + margin) / 2 * x_direction;
	position.y = -System.Window.y / 2 + row * (size.y + margin) + size.y / 2;
	return position;
