static func start(home : Home):
	set_visuals(home);
	generate_instance_id(home);
	open_nexus(home);

static func set_visuals(home : Home):
	OS.set_current_screen(1);
	home.camera.current = true;
	
static func generate_instance_id(home : Home):
	home.random.randomize();
	System.init(home.random);
	home.player_id = System.Id.get_player_id(home.random);

static func open_nexus(home : Home):
	home.PageLoader.open_nexus(home);
