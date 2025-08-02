extends CanvasLayer

@export var default: Texture
@export var hover: Texture
@export var hold: Texture

enum CURSOR_STATE {
	DEFAULT,
	HOVER,
	HOLD
}

var current_state = CURSOR_STATE.DEFAULT

func _ready() -> void:
	Input.set_custom_mouse_cursor(default)

func set_state(state: CURSOR_STATE) -> void:
	current_state = state
	match state:
		CURSOR_STATE.DEFAULT:
			Input.set_custom_mouse_cursor(default)
		CURSOR_STATE.HOVER:
			Input.set_custom_mouse_cursor(hover)
		CURSOR_STATE.HOLD:
			Input.set_custom_mouse_cursor(hold)

func is_holding() -> bool:
	return current_state == CURSOR_STATE.HOLD
