extends Node


const DrawingButton = preload("res://ui/drawing_button.tscn")

var symbol = null


func set_context(new_symbol):
	symbol = new_symbol


func update_screen() -> bool:
	var node = get_node("HBoxLayout/ScrollSymbol/MarginSymbol/VBoxSymbol/HFlowDrawings")
	# remove current buttons
	for ch in node.get_children():
		node.remove_child(ch)
		ch.queue_free()

	if not symbol:
		return false

	var title = get_node("HBoxLayout/ScrollSymbol/MarginSymbol/VBoxSymbol/LabelSymbol")
	title.text = symbol.name

	for drawing in symbol.drawings:
		var but = DrawingButton.instance()
		but.set_context(drawing)
		but.connect("pressed", WoPEditor, 'goto_screen', ['drawing', drawing])
		node.add_child(but)

	return true
