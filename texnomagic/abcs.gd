extends Reference


const Common = preload("res://texnomagic/common.gd")
const Abc = preload("res://texnomagic/abc.gd")

var common = Common.new()
var paths = common.ALPHABETS_PATHS
var abcs = {}


func load() -> bool:
	abcs = {}
	for tag in paths:
		abcs[tag] = get_alphabets(paths[tag])
	return abcs


func get_alphabets(path : String):
	var _abcs = []
	var dir = Directory.new()
	var error = dir.open(path)
	
	if error != OK:
		print("abcs dir doesn't exist: ", path)
		return _abcs
	
	dir.list_dir_begin(true, true)
	var abc_dir = dir.get_next()
	while (abc_dir != ""):
		if dir.current_is_dir():
			var abc_path = path + '/' + abc_dir
			var abc_info_path = abc_path + '/' + 'texno_alphabet.json'
			if dir.file_exists(abc_info_path):
				var abc = Abc.new(abc_path)
				abc.load()
				_abcs.append(abc)
		abc_dir = dir.get_next()

	return _abcs
