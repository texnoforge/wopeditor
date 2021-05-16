extends Reference


var client


func get_client():
	client = StreamPeerTCP.new()
	return client
	
