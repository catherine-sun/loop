extends AspectRatioContainer

@export var iconTexture: Texture2D
@export var label: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	$TextureRect/Sprite2D.texture = iconTexture
	$MenuTextureButton/RichTextLabel.text = label
