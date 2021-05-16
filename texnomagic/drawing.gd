extends Reference

var path : String
var name : String
var curves = []
var points = []


func _init(new_path):
	set_path(new_path)


func set_path(new_path):
	path = new_path
	name = path.get_file()


func load() -> bool:
	var data_file = File.new()
	var error = data_file.open(path, File.READ)
	if error != OK:
		return false
	# TODO read CSV into curves/points
	data_file.close()
	return true
