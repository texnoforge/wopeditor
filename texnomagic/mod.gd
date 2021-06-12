extends Node


var data = {}
var mod_name
var mod_name_id
var mod_filename
var profile_url
var binary_url
var logo_url


func load_from_data(new_data):
	data = new_data
	mod_name = data.get('name')
	mod_name_id = data.get('name_id')
	profile_url = data.get('profile_url')
	var modfile = data.get('modfile', {})
	filename = modfile.get('filename')
	binary_url = modfile.get('download', {}).get('binary_url')
	logo_url = data.get('logo', {}).get('thumb_320x180')
