extends StaticBody2D

var dragging = false
var of = Vector2.ZERO
var viewport_size
var size

var totalDistance = 0
var distOfLastNewSegment = 0

signal new_segment_please

var id = -1
func _ready() -> void:
	of = position
	size = $CollisionShape2D.shape.size
	viewport_size = get_viewport_rect().size

func _process(_delta: float) -> void:
	if dragging:
		var pos = get_global_mouse_position() - of
		var prev = Vector2(position.x, position.y)
		position = Vector2(
			clamp(pos.x, size.x/2, viewport_size.x - size.x/2),
			clamp(pos.y, size.y/2, viewport_size.y - size.y/2)
		)
		distOfLastNewSegment += sqrt(pow(position.x - prev.x, 2) + pow(position.y - prev.y, 2) )
		if (distOfLastNewSegment > 120):
			distOfLastNewSegment = 0
			print("Emitting signal")
			emit_signal("new_segment_please", id)

func setId(i):
	id = i
	
func _on_button_button_down() -> void:
	dragging = true
	of = get_global_mouse_position() - global_position

func _on_button_button_up() -> void:
	dragging = false
