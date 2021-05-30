extends BaseDialog

var batch_ch
var name_e
var meaning_e


func _ready():
	context_name = 'symbol'
	._ready()


func get_fields():
	batch_ch = get_node("CenterContainer/Panel/Margin/VBox/Grid/CheckBatch")
	name_e = get_node("CenterContainer/Panel/Margin/VBox/Grid/EditName")
	meaning_e = get_node("CenterContainer/Panel/Margin/VBox/Grid/EditMeaning")


func reset_fields():
	batch_ch.pressed = batch
	name_e.text = ''
	meaning_e.text = ''


func validate_fields():
	var name = name_e.text
	var meaning = meaning_e.text
	if not name and not meaning:
		show_error('Name or Meaning is required')
		return false
	if not meaning:
		meaning_e.text = name.to_lower()
	if not name:
		name_e.text = meaning.capitalize()
	return true


func on_submit():
	context.name = name_e.text
	context.meaning = meaning_e.text


func _on_CheckBatch_toggled(button_pressed):
	batch = button_pressed
