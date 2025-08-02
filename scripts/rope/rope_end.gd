extends RigidBody2D

@export var drag_force_strength: float
@export var drag_linear_damp: float

var dragging = false
var of = Vector2.ZERO
var viewport_size
var size
var original_linear_damp
var cursor_manager

var totalDistance = 0
var distOfLastNewSegment = 0

signal new_segment_please

var id = -1
func _ready() -> void:
	of = position
	size = $CollisionShape2D.shape.size
	viewport_size = get_viewport_rect().size
	original_linear_damp = linear_damp

	cursor_manager = get_node("/root/CursorManager") # Alternative path

	var button = $CollisionShape2D/Sprite2D/Button
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)

func _physics_process(_delta: float) -> void:
	if dragging:
		var target_pos = get_global_mouse_position() - of
		var clamped_pos = Vector2(
			clamp(target_pos.x, size.x/2, viewport_size.x - size.x/2),
			clamp(target_pos.y, size.y/2, viewport_size.y - size.y/2)
		)
		distOfLastNewSegment += sqrt(pow(position.x - prev.x, 2) + pow(position.y - prev.y, 2) )
		if (distOfLastNewSegment > 120):
			distOfLastNewSegment = 0
			print("Emitting signal")
			emit_signal("new_segment_please", id)
		var direction = (clamped_pos - global_position)
		var force = direction.normalized() * drag_force_strength
		apply_central_force(force)

func setId(i):
	id = i

func _on_mouse_entered() -> void:
	if cursor_manager and not cursor_manager.is_holding():
		cursor_manager.set_state(cursor_manager.CURSOR_STATE.HOVER)

func _on_mouse_exited() -> void:
	if cursor_manager and not cursor_manager.is_holding():
		cursor_manager.set_state(cursor_manager.CURSOR_STATE.DEFAULT)

func _on_button_button_down() -> void:
	dragging = true
	of = get_global_mouse_position() - global_position
	linear_damp = drag_linear_damp
	if cursor_manager:
		cursor_manager.set_state(cursor_manager.CURSOR_STATE.HOLD)

func _on_button_button_up() -> void:
	dragging = false
	linear_damp = original_linear_damp
	if cursor_manager:
		cursor_manager.set_state(cursor_manager.CURSOR_STATE.DEFAULT)
