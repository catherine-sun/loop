extends Node2D

@export var nextScreen: PackedScene

var maxScale = Vector2(1.1,1.1)
var minScale = Vector2(1,1)
const scaleSpeed = 0.03
var scaleMag = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxScale = $CanvasLayer/KnotIcon.scale + Vector2(0.02,0.02)
	minScale = $CanvasLayer/KnotIcon.scale
	$CanvasLayer.scale = Vector2(0.8,0.8)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	UiManager.handleScale($CanvasLayer/KnotIcon, minScale, maxScale, delta, 0.0031, true)

	handleScale($CanvasLayer/PanelContainer/Modal, Vector2(0.345099,0.431954), Vector2(0.365099,0.451954), delta, 0.0061)
	UiManager.handleScale($CanvasLayer, Vector2(0,0), Vector2(1,1), delta, 0.11, false)

func handleScale(node, min, max, delta, speed):
	if node.scale.x == max.x and node.scale.y == max.y:
		scaleMag = -1
	elif node.scale.x == min.x and node.scale.y == min.y:
		scaleMag = 1
	var step = speed*delta*scaleMag
	node.scale = Vector2(clamp(node.scale.x + step , min.x, max.x), clamp(node.scale.y + step , min.y, max.y))
	
func setKnotName(name):
	$CanvasLayer/ReferenceRect/KnotName.text = name


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_packed(nextScreen)
	$CanvasLayer.scale = Vector2(0.8,0.8)
	LevelManager.removeLevelComplete()
