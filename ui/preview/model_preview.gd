extends Control

const Ellipse = preload("res://ui/draw/ellipse.tscn")

var symbol
var label
var els = []

var color_drawing = Color(1, 1, 1, 0.3)
var color_comp = Color(1, 0, 0, 0.5)


func _ready():
	label = get_node("Center/Label")


func set_context(value):
	symbol = value
	update()


func show_label(value):
	label.text = value
	label.visible = true


func _draw():
	if not symbol or not symbol.model:
		return show_label("[no model]")
	if not symbol.model.preview:
		return show_label("[model preview not available]")
	var type = symbol.model.preview.get('type')
	if type != 'gmm':
		return show_label("[unknown preview type: %s]" % type)
	var comps = symbol.model.preview.get('components')
	if not comps:
		return show_label("[preview has no components (?!)]")

	label.visible = false

	# draw all drawings
	for drawing in symbol.drawings:
		for curve in drawing.curves_fit_area(rect_size):
			if curve.size() < 2:
				continue
			draw_polyline(curve, color_drawing, 3)

	# display ellipses for GMM components
	var k = min(rect_size.x, rect_size.y) / Common.points_range
	var max_range = Common.points_range * k
	var offset = Vector2(rect_size.x - max_range, rect_size.y - max_range) / 2

	for i in len(comps):
		var comp = comps[i]
		var el
		if i >= els.size():
			el = Ellipse.instance()
			els.append(el)
			add_child(el)
		else:
			el = els[i]

		var pos = Vector2(comp[0][0], comp[0][1])
		var size = Vector2(comp[1][0], comp[1][1])
		var angle = comp[2]
		# copmonent weight could be used to shade the ellipse
		# var weight = comp[3]

		el.rect_size = size * k
		el.rect_pivot_offset = el.rect_size / 2
		el.rect_rotation = angle
		el.rect_position = pos * k + offset - el.rect_pivot_offset

	# free unused ellipses
	for i in max(len(els) - len(comps), 0):
		var el = els.pop_back()
		remove_child(el)
		el.queue_free()
