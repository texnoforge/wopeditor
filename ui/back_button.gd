extends Button


func _ready():
	var r = connect("pressed", WoPEditor, "go_back")
	assert(r == OK)
