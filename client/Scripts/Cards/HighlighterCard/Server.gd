static func load_variant(high_card : HighlighterCard, force_download : bool = false):
	if !System.Cards.Variants.needs_download(high_card, force_download):
		return;
	System.Server.request(high_card.variant_download_request, high_card, "variant_loaded", true);

static func load_sound(card : HighlighterCard):
	card.Server0.load_sound(card);
