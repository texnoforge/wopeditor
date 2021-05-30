extends Button

export var path : String setget set_path


func _on_pressed():
	if not path:
		print("ERROR: open dir path not set")
		return
	Common.open_dir(path)


func set_path(new_path):
	path = ProjectSettings.globalize_path(new_path)
