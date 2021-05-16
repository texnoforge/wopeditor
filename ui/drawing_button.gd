extends Button


var drawing


func set_context(new_drawing):
	drawing = new_drawing
	if drawing:
		text = drawing.name
