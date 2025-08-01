extends AspectRatioContainer


func _ready():
	var gradient = Gradient.new()
	gradient.offsets = []
	gradient.colors = []
	gradient.add_point(0.0, Color(1, 0.5, 0))
	gradient.add_point(1.0, Color(1, 0.5, 0))

	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient

	$MenuTextureButton.texture_normal = gradient_texture

	gradient = Gradient.new()
	gradient.offsets = []
	gradient.colors = []
	gradient.add_point(0.0, Color(1, 0.3, 0.1))
	gradient.add_point(1.0, Color(1, 0.3, 0.1))

	gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient

	$MenuTextureButton.texture_pressed = gradient_texture
	gradient = Gradient.new()
	gradient.offsets = []
	gradient.colors = []
	gradient.add_point(0.0, Color(1, 0.4, 0.1))
	gradient.add_point(1.0, Color(1, 0.4, 0.1))

	gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient

	$MenuTextureButton.texture_hover = gradient_texture
