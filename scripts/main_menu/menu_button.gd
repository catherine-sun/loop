extends AspectRatioContainer

@export var iconTexture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
		
	$MenuTextureButton.texture_normal = iconTexture
	$MenuTextureButton.ignore_texture_size = true
	$MenuTextureButton.stretch_mode = TextureButton.STRETCH_SCALE
