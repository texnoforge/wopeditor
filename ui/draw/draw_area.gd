extends Control

signal drawing_modified

var is_drawing = false
var curve = PoolVector2Array()
var curves = []


func _gui_input(event):
	if event is InputEventMouseMotion:
		if is_drawing:
			curve.append(event.position)
			update()
	elif event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				start_drawing()
			else:
				end_drawing()
	else:
		print("??? unknown draw area event: %s" % event)


func _draw():
	# border
	draw_rect(Rect2(rect_position, rect_size - Vector2(1,1)), Color.gray, false)
	# curves
	for c in curves + [curve]:
		if c.size() >= 2:
			draw_polyline(c, Color.white, 2, true)


func curves_json():
	var json = []
	for c in curves:
		var jcurve = []
		for p in c:
			jcurve.append([p.x, p.y])
		json.append(jcurve)
	return json


func clear():
	is_drawing = false
	curve = PoolVector2Array()
	curves = []
	$Info.visible = true
	update()


func start_drawing():
	is_drawing = true
	$Info.visible = false


func end_drawing():
	if curve.size() >= 2:
		curves.append(curve)
	curve = PoolVector2Array()
	is_drawing = false
	emit_signal("drawing_modified")


func undo():
	if curves.size() >= 1:
		curves.pop_back()
		update()
		emit_signal("drawing_modified")


func got_curves():
	return curves.size() >= 1
