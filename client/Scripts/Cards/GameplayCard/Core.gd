static func update_visuals(card : GameplayCard):
	System.Cards.update_visuals(card);

static func play_sound(location : String, data : PoolByteArray, card : GameplayCard, do_store : bool = true):
	if data.size() == 0:
		return;
	card.emit_signal("sound_loaded", location, data, do_store, card);

static func start_downloading_variant(card : GameplayCard):
	var download_timer : Timer = card.variant_download_timer;
	download_timer.wait_time = card.random.randf_range(0.01, 0.19);
	download_timer.start();
