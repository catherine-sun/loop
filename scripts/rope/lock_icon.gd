extends Sprite2D

@export var lock_open_texture: Texture2D = preload("res://assets/images/lock_open.png")
@export var lock_closed_texture: Texture2D = preload("res://assets/images/lock_closed.png")

var is_locked: bool = false

func _ready():
	texture = lock_open_texture

func set_locked(locked: bool):
	is_locked = locked
	if is_locked:
		texture = lock_closed_texture
	else:
		texture = lock_open_texture

func toggle_lock():
	set_locked(!is_locked)

func get_is_locked() -> bool:
	return is_locked
