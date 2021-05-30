extends Reference

var path: String
var name = 'N/A'
var curves = []
var points_range = 1000


func _init(new_path = ''):
	set_path(new_path)


func set_path(new_path):
	path = new_path
	if path:
		name = path.get_file()


func load():
	curves = []
	var file = File.new()
	var error = file.open(path, File.READ)
	if error != OK:
		return false
	# read CSV into curves
	var curve = PoolVector2Array()
	while ! file.eof_reached():
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


func save():
	var file = File.new()
	var line : PoolStringArray
	var error = file.open(path, File.WRITE)
	if error != OK:
		return error
	var first = true
	for curve in curves:
		if first:
			first = false
		else:
			# empty line as a curve delimiter
			line = PoolStringArray([])
			file.store_csv_line(line)

		for point in curve:
			line = PoolStringArray([String(point[0]), String(point[1])])
			file.store_csv_line(line)
	file.close()
	return OK


func delete():
	print("DELETE drawing: %s" % name)
	if not path:
		return ERR_FILE_NOT_FOUND
	var dir = Directory.new()
	var r = dir.remove(path)
	return r


func points_min_max():
	if not curves or not curves[0]:
		return null
	
	# get points min/max
	var p_min = curves[0][0]
	var p_max = p_min
	for curve in curves:
		for p in curve:
			if p.x < p_min.x:
				p_min.x = p.x
			elif p.x > p_max.x:
				p_max.x = p.x
			if p.y < p_min.y:
				p_min.y = p.y
			elif p.y > p_max.y:
				p_max.y = p.y
	return [p_min, p_max]


func normalize():
	"""
	normalize drawing points in-place into <0, self.points_range> range
	"""
	if not curves or not curves[0]:
		return
	
	var r = points_min_max()
	var p_min = r[0]
	var p_max = r[1]
	var p_range = p_max - p_min
	var o_range = max(p_range.x, p_range.y)
	var offset = Vector2(o_range - p_range.x, o_range - p_range.y) / 2 - p_min
	var k = points_range / max(p_range.x, p_range.y)
	if abs(k - 1) < 0.001 and abs(offset.x) < 0.001 and abs(offset.y) < 0.001:
		# already normalized
		return
	
	print("NORMALIZE: k = %s, offset = %s" % [k, offset])	
	
	for ic in range(curves.size()):
		var curve = curves[ic]
		for ip in range(curve.size()):
			curves[ic][ip] = (offset + curve[ip]) * k


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
