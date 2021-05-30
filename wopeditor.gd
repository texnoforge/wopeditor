extends Node

var Abcs = preload("res://texnomagic/abcs.gd")
var Server = preload("res://texnomagic/server.gd")

var server = Server.new()
var screens = {}
var past_screens = []
var screen = null
var screen_name: String
var abcs
var abc
var symbol
var drawing


func _ready():
	abcs = Abcs.new()
	abcs.load()
	server.ensure_server()
	Client.connect_to_server()
	var r = Client.connect("query_response", self, "query_response")
	assert(r == OK)
	goto_screen('abcs', abcs)


func load_screen(name):
	print("loading screen: %s" % name)
	return load("res://ui/screens/%s_screen.tscn" % name).instance()


func get_screen(name):
	if not name in screens:
		screens[name] = load_screen(name)
	return screens[name]


func goto_screen(name, context):
	call_deferred("_goto_screen", name, context)


func _goto_screen(name, context):
	var root = get_tree().get_root()
	if screen_name and context:
		past_screens.append(screen_name)
		if name == 'abc':
			abc = context
		elif name == 'symbol':
			symbol = context
		elif name == 'drawing':
			drawing = context
	# remove current active screen
	var prev_screen = root.get_child(root.get_child_count() - 1)
	root.remove_child(prev_screen)
	screen = get_screen(name)
	if context:
		screen.set_context(context)
	screen.update_screen()
	root.add_child(screen)
	screen_name = name


func go_back():
	call_deferred("_go_back")


func _go_back():
	if not past_screens:
		return
	var prev_screen_name = past_screens.pop_back()
	_goto_screen(prev_screen_name, null)


func _reload_abcs():
	print("RELOAD alphabets")
	abcs.load()
	_goto_screen('abcs', null)


func _reload_abc():
	print("RELOAD alphabet")
	abc.load()
	_goto_screen('abc', null)


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		server.kill_server()


func new_abc(_abc):
	abcs.save_new_alphabet(_abc)
	print("NEW alphabet: %s @ %s" % [_abc.name, _abc.path])
	call_deferred('_reload_abcs')


func new_symbol(_symbol, batch = false):
	abc.save_new_symbol(_symbol)
	print("NEW symbol: %s @ %s" % [_symbol.name, _symbol.path])
	_reload_abc()
	if batch:
		screen.call_deferred('show_new_symbol_dialog')



func test_server():
	print("TEST TexnoMagic server connection...")
	var q = {
		'query': 'spell',
		'text': 'big slow ice death fast homing bolt random',
	}
	Client.send_query(q)


func query_response(q):
	print("QUERY RESPONSE: %s" % q['status'])
	print()
