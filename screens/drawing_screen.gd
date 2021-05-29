extends Node


var drawing = null


func set_context(new_drawing):
	drawing = new_drawing


func update_screen() -> bool:
	var title = get_node("HBoxLayout/ScrollDrawing/MarginDrawing/VBoxDrawing/LabelDrawing")
	var drawing_p = get_node("HBoxLayout/ScrollDrawing/MarginDrawing/VBoxDrawing/DrawingPreview")

	if not drawing:
		drawing_p.set_context(drawing)
		title.text = 'drawing'
		return false

	drawing_p.set_context(drawing)
	title.text = drawing.name
	return true
