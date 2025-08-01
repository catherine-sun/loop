extends GridContainer

@export var level_image: Texture2D
@export var level_image_hover: Texture2D

@export var level_data: JSON

var levels = {}
func _ready() -> void:
	var levels = level_data.get_data()
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

		levelBox.texture_normal = level_image
		levelBox.texture_hover = level_image_hover
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
