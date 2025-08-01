extends "res://main_menu/menu_button.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
		
	var imageTexture = ImageTexture.new()
	imageTexture.set_image(Image.load_from_file("res://main_menu/infinityButton.png"))
	$MenuTextureButton.texture_normal = imageTexture
	$MenuTextureButton.ignore_texture_size = true
	$MenuTextureButton.stretch_mode = TextureButton.STRETCH_SCALE
