extends Reference

var texnomagic_server_path = 'texnomagic-server/texnomagic-server'
var server
var server_path


func ensure_server():
	if server and server > 0:
		return true
	var bin_path = OS.get_executable_path()
	var bin_ext = bin_path.get_extension()
	var base_path = ProjectSettings.globalize_path("res://")
	if base_path:
		base_path += 'dist/wopeditor'
	else:
		base_path = bin_path.get_base_dir()

	server_path = base_path + '/' + texnomagic_server_path
	if bin_ext == 'exe':
		server_path += '.exe'
	if not File.new().file_exists(server_path):
		print("TexnoMagic server not found: %s" % server_path)
		return false
	print("START TexnoMagic server: %s" % server_path)
	server = OS.execute(server_path, [], false)
	if server > 0:
		print("SUCCESS TexnoMagic server started with PID: %s" % server)
	else:
		print("FAIL to start TexnoMagic server: %s" % server)
	return true


func kill_server():
	if server and server > 0:
		var r = OS.kill(server)
		print("KILL TexnoMagic server %s: %s" % [server, r])
	else:
		print("TexnoMagic server not running")
