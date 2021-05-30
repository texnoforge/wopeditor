extends Control


var is_drawing = false
var curve = PoolVector2Array()
var curves = []
var info


func _ready():
	info = get_node("Info")


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


func clear():
	print("CLEAR")
	is_drawing = false
	curve = PoolVector2Array()
	curves = []
	info.visible = true
	update()


func start_drawing():
	print("START DRAW")
	is_drawing = true
	info.visible = false


func end_drawing():
	print("END DRAW")
	if curve.size() >= 2:
		curves.append(curve)
	curve = PoolVector2Array()
	is_drawing = false


func undo():
	print("UNDO")
	if curves.size() >= 1:
		curves.pop_back()
		update()


func got_curves():
	return curves.size() >= 1
