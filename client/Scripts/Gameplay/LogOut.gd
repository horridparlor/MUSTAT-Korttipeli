extends GameplayLogOut

func _on_LogOut_pressed():
	emit_signal("log_out");
