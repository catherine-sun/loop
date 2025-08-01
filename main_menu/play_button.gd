extends "res://main_menu/menu_button.gd"

const LEVEL_SELECT = preload("res://level_select/level_select.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
		
	var imageTexture = ImageTexture.new()
	imageTexture.set_image(Image.load_from_file("res://main_menu/playButton.png"))
	$MenuTextureButton.texture_normal = imageTexture
	$MenuTextureButton.ignore_texture_size = true
	$MenuTextureButton.stretch_mode = TextureButton.STRETCH_SCALE
	$MenuTextureButton.connect("pressed", _on_play_button_pressed)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_SELECT) # Replace with function body.
