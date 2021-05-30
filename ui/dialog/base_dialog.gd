extends PopupPanel
class_name BaseDialog

signal confirmed

var context
var context_name = 'thing'
var type = 'new'
var error_l
var header_l


func _ready():
	get_nodes()


func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		# clicking outside of inner pannel closes popup   
		hide()


func get_nodes():
	error_l = get_node("CenterContainer/Panel/Margin/VBox/Error")
	header_l = get_node("CenterContainer/Panel/Margin/VBox/Header")
	get_fields()


func get_fields():
	pass


func reset_fields():
	pass


func validate_fields():
	return true


func on_submit():
	pass


func show_dialog(new_context, new_type='new'):
	context = new_context
	type = new_type
	reset()
	popup_centered_ratio(1)


func reset():
	reset_fields()
	header_l.text = '%s %s' % [type, context_name]
	hide_error()


func show_error(msg):
	error_l.text = msg
	error_l.visible = true


func hide_error():
	error_l.visible = false


func validate():
	if not validate_fields():
		return false
	hide_error()
	return true


func submit():
	if not validate():
		return
	on_submit()	
	emit_signal("confirmed", context, type)
	hide()


func _on_Cancel_pressed():
	hide()


func _on_Confirm_pressed(_arg=null):
	submit()
