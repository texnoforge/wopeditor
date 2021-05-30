extends Node

var user_data_path = 'user://user'
var mods_data_path = 'user://mods'
var export_path = 'user://export'

var alphabets_dir = 'alphabets'
var alphabets_paths = {
	'user': user_data_path + '/' + alphabets_dir,
	'mods': mods_data_path + '/' + alphabets_dir,
}


func name2fn(name):
	var rex = RegEx.new()
	rex.compile("\\s+")
	var fn = name.to_lower()
	fn = rex.sub(fn, '-', true)
	return fn


func makedirs(path):
	var d = Directory.new()
	if d.dir_exists(path):
		return OK
	d.open("user://")
	return d.make_dir_recursive(path)


func open_dir(path):
	print("OPEN DIR: %s" % path)
	var r = OS.shell_open(str("file://", path))
	if r != OK:
		print("ERROR: unable to open dir: %s" % r)
