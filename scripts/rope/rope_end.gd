extends Sprite2D

@export var xlim: float
@export var ylim: float

var dragging = false

var of = Vector2.ZERO
var size
var viewport_size

func _ready() -> void:
	size = get_rect().size
	viewport_size = get_viewport_rect().size

func _process(_delta: float) -> void:
	if dragging:
		var pos = get_global_mouse_position() - of
		position = Vector2(
			clamp(pos.x, size.x/2, viewport_size.x - size.x/2),
			clamp(pos.y, size.y/2, viewport_size.y - size.y/2)
		)

func _on_button_button_down() -> void:
	dragging = true
	of = get_global_mouse_position() - global_position
	

func _on_button_button_up() -> void:
	dragging = false
