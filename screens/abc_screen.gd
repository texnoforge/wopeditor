extends Node


const SymbolButton = preload("res://ui/symbol_button.tscn")

var abc = null


func set_context(new_abc):
	abc = new_abc


func update_screen() -> bool:
	var node = get_node("HBoxLayout/ScrollAbc/MarginAbc/VBoxAbc/HFlowSymbols")
	# remove current buttons
	for ch in node.get_children():
		node.remove_child(ch)
		ch.queue_free()

	if not abc:
		return false

	var title = get_node("HBoxLayout/ScrollAbc/MarginAbc/VBoxAbc/LabelAbc")
	title.text = abc.name
	
	abc.load_symbols()
	for symbol in abc.symbols:
		var but = SymbolButton.instance()
		but.set_context(symbol)
		but.connect("pressed", WoPEditor, 'goto_screen', ['symbol', symbol])
		node.add_child(but)

	return true
