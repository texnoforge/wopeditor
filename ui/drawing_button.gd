extends Button

var drawing


func set_context(new_drawing):
	drawing = new_drawing
	var preview = get_node("Margin/VBox/Preview")
	var label = get_node("Margin/VBox/Label")
	preview.set_context(drawing)
	if drawing:
		label.text = drawing.name
	else:
		label.text = 'drawing'
