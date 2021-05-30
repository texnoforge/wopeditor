extends Node

var drawing = null


func set_context(new_drawing):
	drawing = new_drawing


func update_screen() -> bool:
	var header = get_node("Header")
	var drawing_p = get_node("Cols/Main/DrawingPreview")
	var open_dir_b = get_node("Cols/Side/Rows/OpenDirButton")

	if not drawing:
		drawing_p.set_context(drawing)
		header.text = 'drawing'
		return false

	drawing_p.set_context(drawing)
	header.text = drawing.name
	open_dir_b.path = drawing.path.get_base_dir()
	return true
