extends Node

signal response

const Common = preload("res://texnomagic/common.gd")
var common = Common.new()

var host = '127.0.0.1'
var port = 6969
var timeout = 0.3
var cooldown = 1.0
var retries := 3

var client = StreamPeerTCP.new()
var jsonrpc = JSONRPC.new()
var status = StreamPeerTCP.STATUS_NONE
var t_conn = 0.0
var t_retry = 0.0
var last_id := 0

var error = false
var queue = []
var request = null
var requests = {}


func _ready():
	# don't waste frames unless expecting data
	set_process(false)
	# client.set_no_delay(true)


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		disconnect_from_server()


func _process(delta):
	status = client.get_status()

	if status == StreamPeerTCP.STATUS_CONNECTED:
		if request:
			_process_response()
		if not request:
			if queue:
				var req = queue.pop_front()
				_send_request(req)
			else:
				set_process(false)
		return

	if error:
		if retries > 0:
			t_retry += delta
			if t_retry >= cooldown:
				retries -= 1
				t_retry = 0
				print("RETRY connection to TexnoMagic server...")
				connect_to_server()
		else:
			_server_fail("NO CONNECTION to TexnoMagic server :'(")
			set_process(false)
		return

	if status == StreamPeerTCP.STATUS_ERROR:
		_server_fail("ERROR connecting to TexnoMagic server :-o")
	elif status == StreamPeerTCP.STATUS_CONNECTING:  # is connecting
		t_conn += delta
		if t_conn >= timeout:
			error = true
			_server_fail("TIMEOUT connecting to TexnoMagic server :-/")
	elif status == StreamPeerTCP.STATUS_NONE:
		_server_fail("LOST CONNECTION to TexnoMagic server (%s)" % status)


func _process_response():
	var n = client.get_available_bytes()
	if n <= 0:
		# no new data
		return

	var r = client.get_data(4)
	if r[0] != OK:
		return _response_error(JSONRPC.PARSE_ERROR, "FAIL receive head: ERR %s" % r[0])
	var head = r[1]
	if len(head) != 4:
		return _response_error(JSONRPC.PARSE_ERROR, "INVALID header len: %s != 4  [%s]" % [len(head), head])

	r = client.get_data(n - 4)
	if r[0] != OK:
		return _response_error(JSONRPC.PARSE_ERROR, "FAIL receive body: ERR %s" % r[0])
	var body = PoolByteArray(r[1]).get_string_from_utf8()
	r = JSON.parse(body)
	if r.error:
		return _response_error(JSONRPC.PARSE_ERROR, "INVALID JSON in reponse: %s" % r.error_string)
	_response(r.result)


func queue_request(req):
	print("QUEUE: %s" % common.shorten(str(req)))
	queue.append(req)
	set_process(true)


func send_request(_method, _params=[]):
	last_id += 1
	var req = jsonrpc.make_request(_method, _params, last_id)
	status = client.get_status()

	if status == StreamPeerTCP.STATUS_CONNECTED:
		if not request:
			# client free - send immediately
			_send_request(req)
		else:
			# already processing another request
			queue_request(req)
		return OK
	if error or status == StreamPeerTCP.STATUS_ERROR:
		queue_request(req)  # queue to report error
		_server_fail("ERROR: TexnoMagic server not available :'(")
		return FAILED
	if status == StreamPeerTCP.STATUS_NONE:
		# auto (re)connect
		connect_to_server()
		queue_request(req)
		return OK

	if status == StreamPeerTCP.STATUS_CONNECTING:
		queue_request(req)
		return OK

	print("ERROR: unexpected TexnoMagic server fail (%s)" % status)
	return FAILED


func _send_request(req):
	print("SEND: %s" % common.shorten(str(req)))
	var id = req['id']
	assert(id)
	id = str(id)
	assert(! request)
	request = req
	requests[id] = req
	var s = JSON.print(req)
	return _send_string(s)


func _send_string(data):
	var r = client.put_string(data)
	set_process(true)
	return r


func _response(response):
	print("RECV: %s" % common.shorten(str(response)))
	var id = response.get('id')
	if id:
		id = str(id)
	var req = null
	if id in requests:
		req = requests[id]
		requests.erase(id)
	else:
		print("WARNING: no request found for response")
	emit_signal("response", response, req)
	request = null


func _response_error(code, message):
	var id = null
	if request:
		id = request.get('id', null)
	var err = jsonrpc.make_response_error(code, message, id)
	_response(err)


func _server_fail(msg):
	# unable to connect to server
	if not request:
		request = queue.pop_front()
	while request:
		_response_error(-32000, msg)
		request = queue.pop_front()
	error = true


func connect_to_server():
	t_conn = 0.0
	t_retry = 0.0
	error = false
	var r = client.connect_to_host(host, port)
	if r != OK:
		print("FAIL to connect to TexnoMagic server: %s" % r)
		return r
	print("CONNECTING to TexnoMagic server %s:%s ..." % [host, port])
	return r


func disconnect_from_server():
	print("DISONNECTING from TexnoMagic server %s:%s ..." % [host, port])
	client.disconnect_from_host()
	set_process(false)


func get_server_status():
	if status == StreamPeerTCP.STATUS_CONNECTED:
		return 'OK'
	if error or status == StreamPeerTCP.STATUS_ERROR:
		return 'ERROR'
	if status == StreamPeerTCP.STATUS_CONNECTING:
		return '...'
	return '?'


func int2bytes(integer: int):
	var conv = var2bytes(integer)
	var result = PoolByteArray()
	var start_pos = 4
	for i in range(start_pos, conv.size()):
		result.append(conv[i])
	return result


func bytes2int(bytes: PoolByteArray):
	var formated_int = PoolByteArray([2, 0, 0, 0])
	var n = len(bytes)
	assert(n == 4, "bytes2int() invalid len: %s != 4" % n)
	formated_int.append_array(bytes)
	var r = bytes2var(formated_int)
	return r
