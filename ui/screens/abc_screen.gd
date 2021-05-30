extends Node

const Symbol = preload("res://texnomagic/symbol.gd")
const SymbolButton = preload("res://ui/button/symbol_button.tscn")

var abc = null


func _ready():
	var dialog = get_node("SymbolDialog")
	dialog.connect("confirmed", self, "_on_confirm")


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
		symbol.load_drawings()
		var but = SymbolButton.instance()
		but.set_context(symbol)
		but.connect("pressed", WoPEditor, 'goto_screen', ['symbol', symbol])
		node.add_child(but)

	return true


func show_new_symbol_dialog():
	var dialog = get_node("SymbolDialog")
	var symbol = Symbol.new('.')
	dialog.show_dialog(symbol, 'new')


func _on_ButtonNewSymbol_pressed():
	show_new_symbol_dialog()


func _on_confirm(symbol, type = 'new', batch = false):
	assert(type == 'new')
	WoPEditor.call_deferred("new_symbol", symbol, batch)
