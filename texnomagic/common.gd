extends Node


var USER_DATA_PATH = 'user://user'
var MODS_DATA_PATH = 'user://mods'
var EXPORT_PATH = 'user://export'

var ALPHABETS_DIR = 'alphabets'
var ALPHABETS_PATHS = {
	'user': USER_DATA_PATH + '/' + ALPHABETS_DIR,
	'mods': MODS_DATA_PATH + '/' + ALPHABETS_DIR,
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
