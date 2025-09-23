extends GridContainer

@export var level_image: Texture2D
@export var level_image_hover: Texture2D
@export var level_image_disabled: Texture2D
@export var gridFont: Font

var grids = []
var levels = {}

# create the level select screen
func _ready() -> void:
	levels = LevelManager.getLevels()
	var i = 1
	var numLevels = levels["levels"].size()
	for level in levels["levels"]:

		var vbox = VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL

		# Button
		var levelBox = TextureButton.new()
		levelBox.ignore_texture_size = true
		levelBox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		levelBox.size_flags_vertical = Control.SIZE_EXPAND_FILL
		levelBox.stretch_mode = TextureButton.STRETCH_SCALE
		if LevelManager.getUnlockedLevels().any(func(x): return x == level.name):
			levelBox.texture_normal = level_image
			levelBox.texture_hover = level_image_hover
			levelBox.connect("pressed", func(): loadLevel(level))
		else:
			levelBox.texture_normal = level_image_disabled
			levelBox.texture_hover = level_image_disabled

		# Label
		var levelName = Label.new()
		levelName.add_theme_font_override("font", gridFont)
		levelName.set("theme_override_colors/font_color", Color.BROWN)
		levelName.add_theme_constant_override("outline_size", 3)
		levelName.text = str(i) + ". " + level["name"]

		levelName.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		levelName.set("theme_override_font_sizes/font_size", 20)
		levelName.autowrap_mode = TextServer.AUTOWRAP_WORD
		levelName.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		# Build hierarchy
		vbox.add_child(levelBox)
		vbox.add_child(levelName)
		add_child(vbox)
		grids.append(levelBox)
		i+=1
		
func _process(delta: float) -> void:
	for grid in grids:
		UiManager.handleScale(grid, Vector2(1,1), Vector2(1.04, 1.04), delta, 0.002)

func loadLevel(level):
	LevelManager.startLevel(level)
