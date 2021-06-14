tool
extends MarginContainer


export var show_back = true setget set_show_back
export var text = 'Words of Power Editor' setget set_text


func _ready():
	update_title()
	update_back_button()
	update_status()
	$StatusTimer.start()


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


func update_status():
	var st = $Title/MarginRight/HBox/ServerStatus
	var status = WoPEditor.get_server_status()
	var color = Color.yellow
	if status == "OK":
		color = Color.green
	elif status == "ERROR":
		color = Color.red
	st.text = status
	st.set("custom_colors/font_color", color)


func _on_StatusTimer_timeout():
	update_status()
