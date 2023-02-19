extends Node

const Array_ : GDScript = preload("res://Scripts/System/Array.gd");
const Cards : GDScript = preload("res://Scripts/System/Cards.gd");
const Convert : GDScript = preload("res://Scripts/System/Convert.gd");
const Id : GDScript = preload("res://Scripts/System/Id.gd");
const Instance : GDScript = preload("res://Scripts/System/Instance.gd");
const Debug : GDScript = preload("res://Scripts/System/Debug.gd");
const Decklist : GDScript = preload("res://Scripts/System/Decklist.gd");
const Dictionary_ : GDScript = preload("res://Scripts/System/Dictionary.gd");
const Force : GDScript = preload("res://Scripts/System/Force.gd");
const OS_ : GDScript = preload("res://Scripts/System/OS.gd");
const Physics : GDScript = preload("res://Scripts/System/Physics.gd");
const Scale : GDScript = preload("res://Scripts/System/Scale.gd");
const Server : GDScript = preload("res://Scripts/System/Server.gd");
const Stop : GDScript = preload("res://Scripts/System/Stop.gd");
const Test : GDScript = preload("res://Scripts/System/Test.gd");
const Times : GDScript = preload("res://Scripts/System/Times.gd");
const Vectors : GDScript = preload("res://Scripts/System/Vectors.gd");
const Version : float = 1.04;
const Window : Vector2 = Vector2(1080, 1920);
const Zones : GDScript = preload("res://Scripts/System/Zones.gd");

var session_id;

func init(random : RandomNumberGenerator):
	session_id = Id.generate(random);
	delete_logs();

func delete_logs():
	var dir = Directory.new()
	dir.remove("user://logs/godot.log");


func debug(message : String):
	print(message);
