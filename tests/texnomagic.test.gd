extends WAT.Test


const _Client = preload("res://texnomagic/client.gd")
const Server = preload("res://texnomagic/server.gd")

var client = _Client.new()
var server = Server.new()


func pre():
	#server.ensure_server()
	client.connect_to_server()
	add_child(client)
	yield(until_timeout(0.2), YIELD)


func post():
	print("POST TEST")
	client.disconnect_from_server()


func test_connection_status():
	var status = client.client.get_status()
	asserts.is_equal(status, StreamPeerTCP.STATUS_CONNECTED, "client is CONNECTED")


func test_invalid_query():
	client.send_request('KEKW')
	var emit_vals: Array = yield(until_signal(client, "response", 0.5), YIELD)
	var reply = emit_vals[0]
	asserts.is_not_null(reply, "got response")
	asserts.is_equal(reply['error_message'], "invalid request format - no query", "expected error response")


func test_model_preview_missing():
	client.send_request('model_preview')
	var emit_vals: Array = yield(until_signal(client, "response", 0.5), YIELD)
	var reply = emit_vals[0]
	asserts.is_not_null(reply, "got response")
	asserts.is_equal(reply['status'], "error", "error response")
	asserts.string_begins_with("missing required arg", reply['error_message'], "error message")
