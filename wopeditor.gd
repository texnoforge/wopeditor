extends Node2D


var Abcs = preload("res://texnomagic/abcs.gd")

var screens = {}
var past_screens = []
var screen = null
var screen_name : String
var abcs
var abc
var symbol
var drawing


func _ready():
	abcs = Abcs.new()
	abcs.load()
	goto_screen('abcs', abcs)


func load_screen(name):
	print("loading screen: %s" % name)
	return load("res://screens/%s_screen.tscn" % name).instance()


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
	# remove current active screen
	var prev_screen = root.get_child(root.get_child_count() - 1)
	root.remove_child(prev_screen)
	screen = get_screen(name)
	if context:
		screen.set_context(context)
	screen.update()
	root.add_child(screen)
	screen_name = name


func go_back():
	call_deferred("_go_back")


func _go_back():
	if not past_screens:
		return
	var prev_screen_name = past_screens.pop_back()
	_goto_screen(prev_screen_name, null)
	
