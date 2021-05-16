extends Button


func _ready():
	connect("pressed", WoPEditor, "go_back")
