extends Reference

const Abc = preload("res://texnomagic/abc.gd")
const Common = preload("res://texnomagic/common.gd")

var common = Common.new()

var paths = common.alphabets_paths
var abcs = {}


func load() -> bool:
	abcs = {}
	for tag in paths:
		abcs[tag] = get_alphabets(paths[tag])
	return abcs


func get_alphabets(path: String):
	var abcs_l = []
	var dir = Directory.new()
	var error = dir.open(path)

	if error != OK:
		return abcs_l

	dir.list_dir_begin(true, true)
	var abc_dir = dir.get_next()
	while abc_dir != "":
		if dir.current_is_dir():
			var abc_path = path + '/' + abc_dir
			var abc_info_path = abc_path + '/' + 'texno_alphabet.json'
			if dir.file_exists(abc_info_path):
				var abc = Abc.new(abc_path)
				abc.load()
				abcs_l.append(abc)
		abc_dir = dir.get_next()

	return abcs_l


func save_new_alphabet(abc, tag = 'user'):
	assert(abc.name)
	var path = self.paths[tag] + '/' + common.name2fn(abc.name)
	abc.set_path(path)
	abc.save()
	self.abcs[tag].insert(0, abc)
	return abc
