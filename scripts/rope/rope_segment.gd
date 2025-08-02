extends RigidBody2D

signal rope_collision
signal rope_collision_exit

var ropeId = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setRopeIds(i):
	ropeId = i
	
func getRopeIds():
	return ropeId


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print("Signal pls")
	if "RopeSegment" in body.name:
		RopeManager.emit_signal("rope_collision", body, self) # Replace with function body.


func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if "RopeSegment" in body.name:
		RopeManager.emit_signal("rope_collision_exit", body, self) # Replace with function body.
