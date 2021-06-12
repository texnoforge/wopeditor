extends Node

const Abc = preload("res://texnomagic/abc.gd")
const AbcButton = preload("res://ui/button/abc_button.tscn")
const ModButton = preload("res://ui/button/mod_button.tscn")
const Common = preload("res://texnomagic/common.gd")

var common = Common.new()

var abcs
var mods


func _ready():
	var dialog = get_node("AbcDialog")
	dialog.connect("confirmed", self, "_on_confirm")
	var open_dir = get_node("Cols/Side/Rows/OpenDirButton")
	open_dir.path = common.alphabets_paths['user']
	var test = get_node("Cols/Side/Rows/ButtonTestServer")
	test.connect("pressed", WoPEditor, "test_server")


func set_context(ctx):
	abcs = ctx['abcs']
	mods = ctx['mods']


func update_screen():
	var abcs_nodes = {
		'user': get_node("Cols/Main/Rows/HFlowUserAbcs"),
		'mods': get_node("Cols/Main/Rows/HFlowModsAbcs"),
		'online': get_node("Cols/Main/Rows/HFlowOnlineAbcs"),
	}
	for tag in abcs_nodes:
		var node = abcs_nodes[tag]
		# remove current buttons
		for ch in node.get_children():
			node.remove_child(ch)
			ch.queue_free()

		if tag == 'online':
			if not mods:
				continue
			for mod in mods:
				var but = ModButton.instance()
				but.set_context(mod)
				but.connect("pressed", WoPEditor, 'get_mod', [mod])
				node.add_child(but)
			continue

		if not abcs:
			continue

		if tag in abcs.abcs:
			for abc in abcs.abcs[tag]:
				var but = AbcButton.instance()
				but.set_context(abc)
				but.connect("pressed", WoPEditor, 'goto_screen', ['abc', abc])
				node.add_child(but)

	return true


func get_mod_button(_mod):
	for but in $Cols/Main/Rows/HFlowOnlineAbcs.get_children():
		if but.mod == _mod:
			return but
	return null


func _on_confirm(abc, type = 'new', _batch = false):
	assert(type == 'new')
	WoPEditor.call_deferred("new_abc", abc)


func _on_ButtonNewAbc_pressed():
	var dialog = get_node("AbcDialog")
	var abc = Abc.new('.')
	dialog.show_dialog(abc, 'new')


func _on_ButtonReload_pressed():
	WoPEditor.call_deferred("_reload_abcs")
