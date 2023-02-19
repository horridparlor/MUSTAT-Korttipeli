extends NexusGameCenter

func _on_EnterGame_pressed():
	emit_signal("enter_game");
