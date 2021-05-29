extends Node


const AbcButton = preload("res://ui/abc_button.tscn")

var abcs = null


func _ready():
	var but = get_node("HBoxLayout/VBoxSide/ButtonTestServer")
	but.connect("pressed", WoPEditor, "test_server")


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
