extends BaseDialog

var name_e


func _ready():
	context_name = 'alphabet'
	._ready()


func get_fields():
	name_e = get_node("CenterContainer/Panel/Margin/VBox/Grid/EditName")


func reset_fields():
	name_e.text = ''


func validate_fields():
	if not name_e.text:
		show_error('Name is required')
		return false
	return true


func on_submit():
	context.name = name_e.text
