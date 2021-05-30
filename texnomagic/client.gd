extends Node

signal query_response

var host = '127.0.0.1'
var port = 6969
var timeout = 0.2

var client = StreamPeerTCP.new()
var t = 0.0

var error = false
var queue = []
var query = null


func _ready():
	# don't waste frames unless expecting data
	set_process(false)
	#client.set_no_delay(true)


func _process(delta):
	var status = client.get_status()
	if status == StreamPeerTCP.STATUS_CONNECTED:
		if query:
			_process_response()
		if not query:
			if queue:
				var data = queue.pop_front()
				_send_query(data)
			else:
				set_process(false)
		return

	if error or status == StreamPeerTCP.STATUS_ERROR:
		_server_fail("ERROR connecting to TexnoMagic server :(")
	elif status == StreamPeerTCP.STATUS_CONNECTING:  # is connecting
		t += delta
		if t >= timeout:
			error = true
			_server_fail("TIMEOUT - TexnoMagic server not available :-/")
	elif status == StreamPeerTCP.STATUS_NONE:
		_server_fail("LOST connection to TexnoMagic server (%s)" % status)


func _process_response():
	var n = client.get_available_bytes()
	if n <= 0:
		# no new data
		return

	var r = client.get_data(4)
	if r[0] != OK:
		_query_error("FAIL receive head: ERR %s" % r[0])
		return
	var head = r[1]
	if len(head) != 4:
		_query_error("INVALID header len: %s != 4  [%s]" % [len(head), head])
		return

	r = client.get_data(n - 4)
	if r[0] != OK:
		_query_error("FAIL receive body: ERR %s" % r[0])
		return
	var body = PoolByteArray(r[1]).get_string_from_utf8()
	r = JSON.parse(body)
	var resp = null
	if r.error:
		_query_error("INVALID JSON in reponse: %s" % r.error_string)
		return
	resp = r.result
	_query_response(resp)


func send_query(data):
	var status = client.get_status()

	print("SEND %s (status %s/%s)" % [data, status, error])
	if status == StreamPeerTCP.STATUS_CONNECTED:
		if not query:
			# client free - send immediately
			_send_query(data)
		else:
			# already processing another request
			queue_query(data)
		return OK
	if error or status == StreamPeerTCP.STATUS_ERROR:
		queue_query(data)  # queue to report error
		_server_fail("ERROR: TexnoMagic server not available :(")
		return FAILED
	if status == StreamPeerTCP.STATUS_NONE:
		# auto (re)connect
		connect_to_server()
		queue_query(data)
		return OK

	if status == StreamPeerTCP.STATUS_CONNECTING:
		queue_query(data)
		return OK

	print("ERROR: unexpected TexnoMagic server fail (%s)" % status)
	return FAILED


func queue_query(data):
	queue.append(data)
	set_process(true)


func _query_response(response):
	print("RECV %s" % response)
	emit_signal("query_response", response)
	query = null


func _query_error(error_message):
	var q = 'error'
	if query:
		q = query.get('query', 'error')
	var resp = {
		'query': q,
		'status': 'error',
		'error_message': error_message,
	}
	_query_response(resp)


func _send_query(data):
	assert(! query)
	query = data
	var s = JSON.print(data)
	return _send_string(s)


func _send_string(data):
	# send data
	var r = client.put_string(data)
	set_process(true)
	return r


func _server_fail(msg):
	# unable to connect to server
	if not query:
		query = queue.pop_front()
	while query:
		_query_error(msg)
		query = queue.pop_front()
	error = true
	set_process(false)


func connect_to_server():
	t = 0
	error = false
	var r = client.connect_to_host(host, port)
	if r != OK:
		print("FAIL to connect to TexnoMagic server: %s" % r)
		return r
	print("CONNECTING to TexnoMagic server %s:%s ..." % [host, port])
	return r


func disconnect_from_server():
	client.disconnect_from_host()
	set_process(false)


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
