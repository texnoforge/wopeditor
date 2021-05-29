extends Control


var drawing
var width = 3.0


func set_context(value):
	drawing = value


func _draw():
	if not drawing:
		return
	var curves = drawing.curves_fit_area(rect_size)
	for curve in curves:
		if curve.size() < 2:
			continue
		draw_polyline(curve, Color.white, width)
