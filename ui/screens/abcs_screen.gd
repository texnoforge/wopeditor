extends Node

const Abc = preload("res://texnomagic/abc.gd")
const AbcButton = preload("res://ui/button/abc_button.tscn")

var abcs = null


func _ready():
	var test = get_node("HBoxLayout/VBoxSide/ButtonTestServer")
	test.connect("pressed", WoPEditor, "test_server")
	var dialog = get_node("AbcDialog")
	dialog.connect("confirmed", self, "_on_confirm")


func set_context(new_abcs):
	abcs = new_abcs


func update_screen() -> bool:
	var abcs_nodes = {
		'user': get_node("HBoxLayout/ScrollAbcs/MarginAbcs/VBoxAbcs/HFlowUserAbcs"),
		'mods': get_node("HBoxLayout/ScrollAbcs/MarginAbcs/VBoxAbcs/HFlowModsAbcs"),
	}
	for tag in abcs_nodes:
		var node = abcs_nodes[tag]
		# remove current buttons
		for ch in node.get_children():
			node.remove_child(ch)
			ch.queue_free()

		if not abcs:
			continue

		if tag in abcs.abcs:
			for abc in abcs.abcs[tag]:
				var but = AbcButton.instance()
				but.set_context(abc)
				but.connect("pressed", WoPEditor, 'goto_screen', ['abc', abc])
				node.add_child(but)

	return true


func _on_confirm(abc, type = 'new'):
	assert(type == 'new')
	WoPEditor.call_deferred("new_abc", abc)


func _on_ButtonNewAbc_pressed():
	var dialog = get_node("AbcDialog")
	var abc = Abc.new('.')
	dialog.show_dialog(abc, 'new')
