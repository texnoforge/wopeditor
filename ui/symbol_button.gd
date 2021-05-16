extends Button


var symbol


func set_context(new_symbol):
	symbol = new_symbol
	if symbol:
		text = symbol.name
