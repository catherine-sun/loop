extends "res://scripts/main_menu/menu_button.gd"

const LEVEL_SELECT = preload("res://scenes/level_select.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	$MenuTextureButton.connect("pressed", _on_play_button_pressed)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_SELECT) # Replace with function body.
