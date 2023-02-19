extends HTTPRequest
class_name OneTimeRequest

var id : String;
var parent : Node;
var leave_raw : bool;
var time_out_timer : Timer;

func _ready():
	time_out_timer = System.Instance.timer(0, "_on_timeout", self);

func init(request_path : String, new_parent : Node, response_id : String, _leave_raw : bool, timeout : float):
	leave_raw = _leave_raw;
	if System.Debug.REQUESTS and (System.Debug.REQUESTS_FILTER in request_path):
		System.debug(request_path);
	add_parent(new_parent)
	id = response_id;
	self.connect("request_completed", self, "complete_request");
	request(request_path);
	if timeout > 0:
		time_out_timer.wait_time = timeout;
		time_out_timer.start();

func add_parent(new_parent : Node):
	parent = new_parent;
	parent.add_child(self);

func complete_request(result : int, response_code : int, headers : PoolStringArray, body : PoolByteArray):
	time_out_timer.stop();
	var response = [body];
	if !leave_raw:
		response = System.Server.parse_response(body);
	response = parse_response(response);
	if id != "Null":
		parent._on_http_response(id, response);
	queue_free();

func parse_response(response):
	if response == null:
		return [];
	elif System.Test.is_numeric(response):
		return [response];
	return response;

func _on_timeout():
	complete_request(0, 404, [], []);
