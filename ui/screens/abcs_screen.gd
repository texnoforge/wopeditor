extends Node

const Abc = preload("res://texnomagic/abc.gd")
const AbcButton = preload("res://ui/button/abc_button.tscn")

var abcs = null


func _ready():
	var dialog = get_node("AbcDialog")
	dialog.connect("confirmed", self, "_on_confirm")
	var open_dir = get_node("Cols/Side/Rows/OpenDirButton")
	open_dir.path = Common.alphabets_paths['user']
	var test = get_node("Cols/Side/Rows/ButtonTestServer")
	test.connect("pressed", WoPEditor, "test_server")


func set_context(new_abcs):
	abcs = new_abcs


func update_screen():
	var abcs_nodes = {
		'user': get_node("Cols/Main/Rows/HFlowUserAbcs"),
		'mods': get_node("Cols/Main/Rows/HFlowModsAbcs"),
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


func _on_confirm(abc, type = 'new', _batch = false):
	assert(type == 'new')
	WoPEditor.call_deferred("new_abc", abc)


func _on_ButtonNewAbc_pressed():
	var dialog = get_node("AbcDialog")
	var abc = Abc.new('.')
	dialog.show_dialog(abc, 'new')


func _on_ButtonReload_pressed():
	WoPEditor.call_deferred("_reload_abcs")
