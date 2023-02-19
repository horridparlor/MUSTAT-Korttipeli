extends NexusDeckBuilderCollection

func _on_SlideCollection_pressed():
	emit_signal("slide_collection");

func _on_SlideCollection_released():
	emit_signal("slide_collection", false);
