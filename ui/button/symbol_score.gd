extends Control

var score := -666.0
var symbol
var drawing


func set_context(new_symbol, new_score):
	symbol = new_symbol
	score = new_score
	var preview = $Margin/VBox/Preview
	var label = $Margin/VBox/Label
	if symbol:
		label.text = "%.2f: %s" % [score, symbol.name]
		drawing = symbol.random_drawing()
	else:
		label.text = 'symbol'
		drawing = null
	preview.set_context(drawing)
