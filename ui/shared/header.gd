tool
extends MarginContainer


export var show_back = true setget set_show_back
export var text = 'Words of Power Editor' setget set_text
export var status = '?' setget set_status


func _ready():
	status = '?'
	update_title()
	update_back_button()


func update_title():
	$Title.text = text


func update_back_button():
	$Title/MarginLeft/BackButton.visible = show_back


func set_text(new_text):
	text = new_text
	update_title()


func set_show_back(new_show):
	show_back = new_show
	update_back_button()


func set_status(new_status):
	status = new_status
	var st = $Title/MarginRight/HBox/ServerStatus
	var color : Color
	if status == "OK":
		color = Color.green
	elif status == "ERROR":
		color = Color.red
	else:
		color = Color.yellow
	st.text = status
	st.set("custom_colors/font_color", color)
