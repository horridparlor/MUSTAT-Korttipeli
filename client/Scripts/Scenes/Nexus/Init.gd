static func init(random_ : RandomNumberGenerator, nexus : Nexus):
	nexus.random = random_;
	connect_signals(nexus);	
	nexus.set_active(true);
	initialize_elements(nexus);

static func connect_highlighter(nexus : Nexus):
	nexus.highlighter.init(nexus.random);
	nexus.highlighter.connect("close", nexus, "highlighter_closed");

static func connect_signals(nexus : Nexus):
	for signal_ in ["open_page"]:
		nexus.page_loader.connect(signal_, nexus, signal_);
	connect_highlighter(nexus);

static func initialize_elements(nexus : Nexus):
	nexus.page_loader.init(nexus.random);
