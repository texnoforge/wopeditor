extends Reference

const Drawing = preload("res://texnomagic/drawing.gd")

var path: String
var info_path: String
var drawings_path: String
var name: String
var meaning: String
var drawings = []


func _init(new_path):
	set_path(new_path)


func set_path(new_path):
	path = new_path
	info_path = path + '/' + 'texno_symbol.json'
	drawings_path = path + '/' + 'drawings'


func load() -> bool:
	var info_file = File.new()
	var error = info_file.open(info_path, File.READ)
	if error != OK:
		return false
	var content = info_file.get_as_text()
	info_file.close()
	var jr = JSON.parse(content)
	if jr.error != OK:
		return false
	var data = jr.result
	if 'name' in data:
		name = data['name']
	if 'meaning' in data:
		meaning = data['meaning']

	return true


func load_drawings() -> bool:
	drawings = []
	var dir = Directory.new()
	var error = dir.open(drawings_path)

	if error != OK:
		print("failed to load drawing directory: %s" % drawings_path)
		return false

	dir.list_dir_begin(true, true)
	var drawing_fn = dir.get_next()
	while drawing_fn != "":
		if drawing_fn.get_extension() == 'csv':
			var drawing_path = drawings_path + '/' + drawing_fn
			if dir.file_exists(drawing_path):
				var drawing = Drawing.new(drawing_path)
				drawing.load()
				drawings.append(drawing)
		drawing_fn = dir.get_next()

	return true


func random_drawing():
	if not drawings:
		return null
	return drawings[randi() % drawings.size()]
