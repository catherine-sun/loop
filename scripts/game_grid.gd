extends Node2D

const GRID_POST = preload("res://components/game_grid/grid_post.tscn")
const ROPES = preload("res://components/rope/rope_generator.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ropes = ROPES.instantiate()
	add_child(ropes)
	var viewport_size = get_viewport_rect().size
	for i in range(70, viewport_size.x, 150):
		for j in range(40, viewport_size.y, 150):
			var post = GRID_POST.instantiate()
			post.position = Vector2(i, j)
			post.collision_layer = 2
			post.collision_mask = 1
			
			add_child(post)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
