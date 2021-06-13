extends Reference

const Common = preload("res://texnomagic/common.gd")
const Drawing = preload("res://texnomagic/drawing.gd")
const Model = preload("res://texnomagic/model.gd")

var common = Common.new()

var path: String
var info_path: String
var drawings_path: String
var model_path: String
var name: String
var meaning: String
var drawings := []
var model


func _init(new_path):
	set_path(new_path)


func set_path(new_path):
	path = new_path
	info_path = path + '/' + 'texno_symbol.json'
	drawings_path = path + '/' + 'drawings'
	model_path = path + '/' + 'model'


func load():
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


func load_drawings():
	drawings = []
	var dir = Directory.new()
	var error = dir.open(drawings_path)

	if error != OK:
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


func load_model():
	var _model = Model.new(model_path)
	var r = _model.load()
	if r:
		model = _model
	else:
		model = null


func save():
	var r = common.makedirs(path)
	assert(r == OK)
	var info = {
		'name': name,
		'meaning': meaning,
	}
	var file = File.new()
	file.open(info_path, File.WRITE)
	file.store_string(JSON.print(info, '  '))


func save_new_drawing(drawing):
	assert(drawing.curves and drawing.curves.size() >= 1)
	common.makedirs(drawings_path)
	var fn = '%s_%s.csv' % [common.name2fn(name), OS.get_unix_time()]
	var dpath = drawings_path + '/' + fn
	print("SAVE NEW DRAWING: %s" % dpath)
	drawing.set_path(dpath)
	var r = drawing.save()
	if r == OK:
		drawings.insert(0, drawing)
	return r


func random_drawing():
	if not drawings:
		return null
	return drawings[randi() % drawings.size()]
