extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StaticBody2D.collision_layer = 2;
	$StaticBody2D.collision_mask = 1;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
