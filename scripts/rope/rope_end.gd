extends RigidBody2D

@export var drag_force_strength: float
@export var drag_linear_damp: float

var dragging = false
var of = Vector2.ZERO
var viewport_size
var size
var original_linear_damp

func _ready() -> void:
	size = $CollisionShape2D.shape.size
	viewport_size = get_viewport_rect().size
	original_linear_damp = linear_damp

func _physics_process(_delta: float) -> void:
	if dragging:
		var target_pos = get_global_mouse_position() - of
		var clamped_pos = Vector2(
			clamp(target_pos.x, size.x/2, viewport_size.x - size.x/2),
			clamp(target_pos.y, size.y/2, viewport_size.y - size.y/2)
		)

		var direction = (clamped_pos - global_position)
		var force = direction.normalized() * drag_force_strength
		apply_central_force(force)

func _on_button_button_down() -> void:
	dragging = true
	of = get_global_mouse_position() - global_position
	linear_damp = drag_linear_damp

func _on_button_button_up() -> void:
	dragging = false
	linear_damp = original_linear_damp
