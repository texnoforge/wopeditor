extends Button

const Common = preload("res://texnomagic/common.gd")

var common = Common.new()

var mod


func _ready():
	var m = $Center/Margin
	rect_min_size = m.rect_size
	var r = $HTTPRequest.connect("request_completed", self, "got_logo")
	assert(r == OK)


func set_context(value):
	mod = value
	$Center/Margin/VBox/Label.text = mod.mod_name
	call_deferred('get_logo')


func get_logo():
	$HTTPRequest.request(mod.logo_url)


func got_logo(result, _response_code, headers, body):
	if result != OK:
		print("ERROR downloading mod logo: %s" % mod.mod_name)
		return

	var image = common.load_image_from_request(headers, body)
	if ! image:
		print("ERROR loading downloaded mod logo image: %s" % mod.mod_name)
		return

	var texture = ImageTexture.new()
	texture.create_from_image(image)

	$Center/Margin/VBox/Texture.texture = texture
