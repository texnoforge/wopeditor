extends Button

var abc


func set_context(new_abc):
	abc = new_abc
	if abc:
		text = abc.name
