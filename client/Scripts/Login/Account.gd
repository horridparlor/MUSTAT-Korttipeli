extends LoginAccount

func _on_Choose_pressed():
	emit_signal("chosen", id);
