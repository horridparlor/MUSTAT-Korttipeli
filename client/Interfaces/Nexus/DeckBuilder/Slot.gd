extends NexusPageButton
class_name NexusDeckBuilderSlot

signal long_press(self_);

const LONG_PRESS_THRESHOLD : float = 2.1;

var long_press_timer : Timer;
var slot_index : int;

func _ready():
	long_press_timer = System.Instance.timer(LONG_PRESS_THRESHOLD, "long_press", self);
