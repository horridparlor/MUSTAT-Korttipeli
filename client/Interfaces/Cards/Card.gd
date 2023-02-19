extends GlowNode
class_name Card

onready var artwork : Sprite = $Artwork;
onready var cost_label : CardStatLabel = $Cost/Label;
onready var name_label : CardStatLabel = $Name;
onready var power_label : CardStatLabel = $Power/Label;
var random : RandomNumberGenerator;

var base_id : int;
var location : String = "Null";
var variant_id : int;
var variant_scale : int = 1;

func activate_visuals(texture : ImageTexture, random : RandomNumberGenerator):
	artwork.texture = texture;
	activate_animations(random);

func flush():
	artwork.texture = null;
	deactivate_animations();
