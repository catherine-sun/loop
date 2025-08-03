extends PanelContainer

const SETTINGS = preload("res://scenes/settings_menu.tscn")
const PLAY = preload("res://scenes/level_select.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_play_button_pressed():
	get_tree().change_scene_to_packed(PLAY)

func _on_endless_button_pressed() -> void:
	pass # Replace with function body.

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_packed(SETTINGS)


func _on_quit_button_pressed() -> void:
	get_tree().quit()  # Replace with function body.
