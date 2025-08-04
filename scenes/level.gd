extends Node2D

const levelScenes = [
	preload("res://components/level_setups/two_ropes.tscn"),
	preload("res://components/level_setups/two_ropes.tscn"),
	preload("res://components/level_setups/three_ropes.tscn")
]

const LEVEL_SELECT = preload("res://scenes/level_select.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var currentLevel = LevelManager.getCurrentLevel()
	var curLevelNode = levelScenes[currentLevel["numRopes"] - 1].instantiate()
	curLevelNode.position = Vector2(27, 117)
	$LevelSetup.add_child(curLevelNode)
	$LevelLabel.text = currentLevel["name"]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	LevelManager.endLevel()
	get_tree().change_scene_to_packed(LEVEL_SELECT)
	pass # Replace with function body.
