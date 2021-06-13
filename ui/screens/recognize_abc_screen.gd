extends VBoxContainer

const SymbolScore = preload("res://ui/button/symbol_score.tscn")

var abc
var scores = []


func set_context(new_abc):
	abc = new_abc
	clear()


func set_scores(new_scores):
	scores = new_scores


func clear():
	scores = []
	$Cols/Main/DrawArea.clear()


func update_screen():
	var scores_node = $Cols/Side/Rows/ScoresScroll/Scores

	# clean existing score widgets
	for ch in scores_node.get_children():
		ch.queue_free()
	
	if ! abc or ! scores:
		return

	for s in scores:
		var symbol_name = s[0]
		var score = s[1]
		var symbol = abc.get_symbol_by_name(symbol_name)
		if not symbol:
			print("ERROR: recognized symbol %s not found in %s alphabet" % [symbol_name, abc.name])
			continue
		
		var ss = SymbolScore.instance()
		ss.set_context(symbol, score)
		ss.connect("pressed", WoPEditor, 'goto_screen', ['symbol', symbol])
		scores_node.add_child(ss)


func do_recognize():
	WoPEditor.recognize_top(abc, $Cols/Main/DrawArea.curves_json(), 8)


func _on_ButtonClear_pressed():
	clear()
	update_screen()


func _on_DrawArea_drawing_modified():
	do_recognize()
