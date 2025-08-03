extends Area2D




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("protec")
	pass
	
func toggleSegments():
	handleSegmentVisibility(getAllRopeSegments(get_parent()))
	
func getAllRopeSegments(node):
	return get_tree().get_nodes_in_group("ropePLEASE")
	
func handleSegmentVisibility(segs):
	var overlapping = get_overlapping_bodies()
	for seg in segs:
		if overlapping.any(func(x): return x.name == seg.name):
			seg.setLeftFeeder(false)
			seg.get_node("Area2D").collision_layer = 5
			seg.get_node("Area2D").collision_mask = 6
			seg.collision_layer = 1
			seg.collision_mask = 2
		else:
			seg.setLeftFeeder(true)
			seg.get_node("Area2D").collision_layer = 5
			seg.get_node("Area2D").collision_mask = 6
			seg.collision_layer = 4
			seg.collision_mask = 11

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass


func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if "RopeSegment" in body.name or "RopeEnd" in body.name:
		body.get_node("Area2D").collision_layer = 5
		body.get_node("Area2D").collision_mask = 6
		body.collision_layer = 4
		body.collision_mask = 11
		body.setLeftFeeder(true)
