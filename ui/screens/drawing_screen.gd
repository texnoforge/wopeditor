extends Node

var drawing = null


func set_context(new_drawing):
	drawing = new_drawing


func update_screen() -> bool:
	var header = get_node("Header")
	var drawing_p = get_node("Cols/Main/DrawingPreview")

	if not drawing:
		drawing_p.set_context(drawing)
		header.text = 'drawing'
		return false

	drawing_p.set_context(drawing)
	header.text = drawing.name
	return true
