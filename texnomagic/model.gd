extends Reference

var path: String
var info_path: String
var n_gauss = 10
var data := {}
var params := []
var preview = null


func _init(new_path):
	set_path(new_path)


func set_path(new_path):
	path = new_path
	info_path = path + '/' + 'texno_model.json'


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
	data = jr.result
	params = data.get('params', [])
	n_gauss = data.get('n_gauss', 10)
