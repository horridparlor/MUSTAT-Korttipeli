extends Node2D
class_name CardAnimations

onready var alpha_timer : Timer;
onready var motion : Particles2D = null;
onready var motions_layer : Node2D = $MotionsLayer;

const FADE_IN_SPEED : float = 1.2;
const FADE_OUT_SPEED : float = 4.3;
const MAX_ALPHA : float = 0.6;

var alpha_direction : int;
var alpha_speed : float;
var current_motion_path : String;
