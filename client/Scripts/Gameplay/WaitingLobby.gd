extends GameplayWaitingLobby

func _ready():
	cancel_button.connect("quit", self, "close_lobby");

func close_lobby():
	emit_signal("quit");
