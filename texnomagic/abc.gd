extends Reference

const Common = preload("res://texnomagic/common.gd")
const Symbol = preload("res://texnomagic/symbol.gd")

var common = Common.new()

var path: String
var info_path: String
var symbols_path: String
var name: String
var symbols = []


func _init(new_path):
	set_path(new_path)


func set_path(new_path):
	path = new_path
	info_path = path + '/' + 'texno_alphabet.json'
	symbols_path = path + '/' + 'symbols'


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
	return true


func load_symbols():
	symbols = []
	var dir = Directory.new()
	var error = dir.open(symbols_path)

	if error != OK:
		return false

	dir.list_dir_begin(true, true)
	var symbol_dir = dir.get_next()
	while symbol_dir != "":
		if dir.current_is_dir():
			var symbol_path = symbols_path + '/' + symbol_dir
			var symbol_info_path = symbol_path + '/' + 'texno_symbol.json'
			if dir.file_exists(symbol_info_path):
				var symbol = Symbol.new(symbol_path)
				symbol.load()
				symbols.append(symbol)
		symbol_dir = dir.get_next()

	return true


func save():
	var r = common.makedirs(path)
	assert(r == OK)
	var info = {
		'name': name,
	}
	var file = File.new()
	file.open(info_path, File.WRITE)
	file.store_string(JSON.print(info, '  '))


func save_new_symbol(symbol):
	assert(symbol.name)
	var spath = symbols_path + '/' + common.name2fn(symbol.name)
	symbol.set_path(spath)
	symbol.save()
	symbols.insert(0, symbol)
	return symbol


func get_symbol_by_name(symbol_name):
	for s in self.symbols:
		if s.name == symbol_name:
			return s
	return null
