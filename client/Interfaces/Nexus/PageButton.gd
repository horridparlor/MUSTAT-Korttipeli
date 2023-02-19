extends GlowNode
class_name NexusPageButton

signal activate(self_);

onready var focused_frame : Panel = $FocusedFrame;
onready var label : Label = $Label;

var button_name : String;

func toggle_active(boolean : bool = true):
	focused_frame.visible = boolean;

func activate():
	toggle_active();

func deactivate():
	toggle_active(false);

func press():
	emit_signal("activate", self);
