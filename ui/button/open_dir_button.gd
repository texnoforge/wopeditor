extends Button

const Common = preload("res://texnomagic/common.gd")

var common = Common.new()

export var path : String setget set_path


func _on_pressed():
	if not path:
		print("ERROR: open dir path not set")
		return
	common.open_dir(path)


func set_path(new_path):
	path = ProjectSettings.globalize_path(new_path)
