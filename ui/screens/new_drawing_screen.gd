extends VBoxContainer

const Drawing = preload("res://texnomagic/drawing.gd")

var symbol
var draw_area
var check_batch


func _ready():
	draw_area = get_node("Cols/Main/DrawArea")
	check_batch = get_node("Cols/Side/Rows/CheckBatch")


func set_context(new_symbol):
	symbol = new_symbol


func update_screen():
	if draw_area:
		draw_area.clear()
	return true


func _save():
	if draw_area.got_curves():
		var drawing = Drawing.new()
		drawing.curves = draw_area.curves
		var batch = check_batch.pressed
		WoPEditor.call_deferred('new_drawing', drawing, batch)
