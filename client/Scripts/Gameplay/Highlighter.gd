extends GameplayHighlighter

func _ready():
	restore();

func init(random : RandomNumberGenerator):
	highlighter_card.random = random;

func _on_Close_pressed():
	if System.Physics.Collision.with_mouse(highlighter_card):
		return;
	restore();
	emit_signal("close");

func eat(card : GameplayCard):
	highlighter_card.eat(card);
	effects.text = card.effects_text;
	visible = true;

func restore():
	visible = false;
	highlighter_card.flush();
