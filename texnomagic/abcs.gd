extends Reference


const Abc = preload("res://texnomagic/abc.gd")

var paths = Common.ALPHABETS_PATHS
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


func save_new_alphabet(abc, tag='user'):
	assert(abc.name)
	var path = self.paths[tag] + '/' + Common.name2fn(abc.name)
	abc.set_path(path)
	abc.save()
	self.abcs[tag].insert(0, abc)
	return abc
