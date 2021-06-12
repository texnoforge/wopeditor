extends Node

# Words of Power @ mod.io
const MODIO_API_KEY = "2071808b470b7abc78fc289e5d3396d1"
const MODIO_API_URL = "https://api.mod.io/v1"
const MODIO_GAME_ID = 1986
const MODIO_MODS_URL = "%s/games/%s/mods" % [MODIO_API_URL, MODIO_GAME_ID]
const MODIO_MODS_URL_GET = "%s?api_key=%s" % [MODIO_MODS_URL, MODIO_API_KEY]

var user_data_path = 'user://user'
var mods_data_path = 'user://mods'
var export_path = 'user://export'

var alphabets_dir = 'alphabets'
var alphabets_paths = {
	'user': user_data_path + '/' + alphabets_dir,
	'mods': mods_data_path + '/' + alphabets_dir,
}

var points_range = 1000.0


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


func shorten(s, max_len=70):
	if len(s) > max_len:
		s = s.left(max_len) + '...'
	return s


func load_image_from_request(headers, body):
	var regex = RegEx.new()
	var ct
	regex.compile("Content-Type:\\s*(?<ct>\\S+)")
	for h in headers:
		var m = regex.search(h)
		if m:
			ct = m.get_string("ct")
			break
	if ! ct:
		print("WARN: HTTP request missing Content-Type")
		return null

	var image = Image.new()
	var r

	match ct:
		'image/png':
			r = image.load_png_from_buffer(body)
		'image/jpeg':
			r = image.load_jpg_from_buffer(body)
		_:
			print("WARN: unknown image format: %s" % ct)
			return null

	if r != OK:
		print("ERROR loading remote image")
		return null

	return image
