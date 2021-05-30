extends Button

var symbol
var drawing


func set_context(new_symbol):
	symbol = new_symbol
	var preview = get_node("Margin/VBox/Preview")
	var label = get_node("Margin/VBox/Label")
	if symbol:
		label.text = "%s (%s)" % [symbol.name, symbol.meaning]
		drawing = symbol.random_drawing()
	else:
		label.text = 'symbol'
		drawing = null
	preview.set_context(drawing)
