extends HighlighterCard

const Core : GDScript = preload("res://Scripts/Cards/HighlighterCard/Core.gd");
const Response : GDScript = preload("res://Scripts/Cards/HighlighterCard/Response.gd");
const Server : GDScript = preload("res://Scripts/Cards/HighlighterCard/Server.gd");
const Server0 : GDScript = preload("res://Scripts/Cards/GameplayCard/Server.gd");

func _ready():
	variant_scale = 4;

func eat(card : GameplayCard):
	Core.eat(card, self);
	Server.load_variant(self);

func _on_http_response(id : String, data : Array):
	Response.route(id, data, self);

func force_variant_download():
	Server.load_variant(self, true);

func _on_SoundButton_pressed():
	location = System.Array_.random_item(["Field", "Grave", "Hand"], random);
	System.Cards.Sound.load_sound(self);
