extends RigidBody2D

signal rope_collision
signal rope_collision_exit

var ropeId = -1
var leftFeeder = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_layer = 1
	collision_mask = 2
	add_to_group("ropePLEASE")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (RopeManager.isInACross(ropeId)):
		get_node("Area2D/Icon").modulate =  Color(1, 1, 0)
	else:
		get_node("Area2D/Icon").modulate =  Color(1, 1, 1)

func setRopeIds(i):
	ropeId = i
	
func getRopeIds():
	return ropeId

func getLeftFeeder():
	return leftFeeder
	
func setLeftFeeder(v):
	leftFeeder = v
	
func updateSegmentCollision():
	collision_layer = 4
	collision_mask = 3

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if "RopeSegment" in body.name:
		RopeManager.emit_signal("rope_collision", body, self) # Replace with function body.


func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if "RopeSegment" in body.name:
		RopeManager.emit_signal("rope_collision_exit", body, self) # Replace with function body.
