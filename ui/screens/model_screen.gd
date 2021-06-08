extends VBoxContainer


var symbol

var n_gauss_box
var train_button
var preview


func get_nodes():
	n_gauss_box = $Cols/Side/Rows/NGaussRow/NGaussBox
	train_button = $Cols/Side/Rows/TrainButton
	preview = $Cols/Main/ModelPreview


func _ready():
	get_nodes()


func set_context(new_symbol):
	symbol = new_symbol
	WoPEditor.update_model_preview(symbol)


func update_screen():
	get_nodes()
	preview.set_context(symbol)
	n_gauss_box.value = symbol.model.n_gauss
	train_button.disabled = false


func do_train():
	if train_button.disabled:
		return
	WoPEditor.train_model(symbol, n_gauss_box.value)
	train_button.disabled = true


func _on_TrainButton_pressed():
	do_train()


func _on_NGaussBox_value_changed(_value):
	do_train()
