extends GlowNode
class_name LoginAccount

signal chosen(id);

onready var name_label : Label = $Name;

const SIZE : Vector2 = Vector2(450, 350);

var id : int;

func set_name(new_name : String):
	name_label.text = new_name;
