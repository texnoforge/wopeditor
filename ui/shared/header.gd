tool
extends MarginContainer


export var show_back = true setget set_show_back
export var text = 'Words of Power Editor' setget set_text


func _ready():
	update_title()
	update_back_button()


func update_title():
	get_node("Title").text = text


func update_back_button():
	get_node("Title/MarginContainer/BackButton").visible = show_back


func set_text(new_text):
	text = new_text
	update_title()


func set_show_back(new_show):
	show_back = new_show
	update_back_button()
