extends CardStatLabel

func rewrite(message : String):
	text = message;
	
func eat(value : int):
	rewrite(str(value));
