extends Reference

var path : String
var name : String
var curves = []
var points_range = 1000


func _init(new_path):
	set_path(new_path)


func set_path(new_path):
	path = new_path
	name = path.get_file()


func load() -> bool:
	curves = []
	var file = File.new()
	var error = file.open(path, File.READ)
	if error != OK:
		return false
	# read CSV into curves
	var curve = PoolVector2Array()
	while !file.eof_reached():
		var line = file.get_csv_line()
		var n = line.size()
		if n >= 2:
			var x = line[0]
			var y = line[1]
			if x and y:
				var point = Vector2(line[0], line[1])
				curve.push_back(point)
				continue
		# next curve
		if curve.size() > 0:
			curves.append(curve)
		curve = PoolVector2Array()
	file.close()
	return true


func curves_fit_area(size):
	var k = min(size[0], size[1]) / points_range
	var max_range = points_range * k

	var offset = Vector2(size[0] - max_range, size[1] - max_range) / 2

	var scurves = []
	for curve in self.curves:
		var scurve = PoolVector2Array()
		for point in curve:
			var p = point * k + offset
			scurve.append(p)
		scurves.append(scurve)
	return scurves
