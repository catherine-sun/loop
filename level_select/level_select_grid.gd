extends GridContainer

var levels = {}
func _ready() -> void:
	var levels = parse_json(load_json())
	print(levels)
	print(levels["levels"])
	
	var i = 1
	var numLevels = levels["levels"].size()
	for level in levels["levels"]:
		
		var aspect_container = AspectRatioContainer.new()
		aspect_container.ratio = 10.0 / 9.0
		aspect_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		aspect_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		var levelBox = TextureButton.new()
		levelBox.ignore_texture_size = true
		levelBox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		levelBox.size_flags_vertical = Control.SIZE_EXPAND_FILL
		levelBox.stretch_mode = TextureButton.STRETCH_SCALE

		var levelBoxTexture = ImageTexture.new()
		levelBoxTexture.set_image(Image.load_from_file("res://level_select/alpaca_snatched.png")) 
		levelBox.texture_normal = levelBoxTexture
		var levelBoxTextureHover = ImageTexture.new()
		levelBoxTextureHover.set_image(Image.load_from_file("res://level_select/alpaca_hug.png")) 
		levelBox.texture_hover = levelBoxTextureHover
		var center_container = CenterContainer.new()
		center_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		center_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		center_container.anchor_left = 0
		center_container.anchor_top = 0
		center_container.anchor_right = 1
		center_container.anchor_bottom = 1
		center_container.offset_left = 0
		center_container.offset_top = 0
		center_container.offset_right = 0
		center_container.offset_bottom = 0

		var levelName = Label.new()
		levelName.set("theme_override_colors/font_color",Color.BROWN)

		levelName.text = "Level " + str(i) + ": " + level["name"]
		levelName.anchor_left = 0
		levelName.anchor_right = 0
		levelName.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		levelName.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		levelName.set("theme_override_font_sizes/font_size", max(30 - floor(numLevels / 3) * 5, 10))
		levelName.autowrap_mode = TextServer.AUTOWRAP_WORD
		levelBox.add_child(center_container)
		center_container.add_child(levelName)
		aspect_container.add_child(levelBox)

		add_child(aspect_container)
		i+=1

func parse_json(string):
	var json = JSON.new()
	var error = json.parse(string)
	if error != OK:
		print("Error loading levels json")
		return null
	return json.get_data()
func load_json():
	var file_path = "res://levels.json"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		return file.get_as_text()
	else:
		push_error("levels.json not found at %s" % file_path)
		return ""
