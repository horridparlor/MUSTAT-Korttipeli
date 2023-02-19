extends GameplayCancelButton

func _on_Quit_pressed():
	emit_signal("quit");
