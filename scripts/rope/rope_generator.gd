extends Node2D

@export var ropeLength: int
@export var ropeSegmentWidth: int

const ROPE_SEGMENT = preload("res://components/rope/rope_segment.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	addRopes(4) # Replace with function body.
	
func addRopes(numRopes):
	for i in range(numRopes):
		var ropeContainer = Node2D.new()
		add_child(ropeContainer)
		addRopeSegments(ropeContainer)
		ropeContainer.rotate(i * 0.1)
		
func addRopeSegments(parent):
	var head = $RopeHolder
	var tail =  $RopeHolder
	var pos = Vector2($RopeHolder.position.x, $RopeHolder.position.y)
	print(ropeLength)
	for i in range(ropeLength):
		print(pos)
		var joint = PinJoint2D.new()
		joint.position = pos if i == 0 else Vector2(pos.x + ropeSegmentWidth/2, pos.y)
		parent.add_child(joint)
		joint.node_b = tail.get_path()
		var newRopeSegment = ROPE_SEGMENT.instantiate()
		if i > 0:
			newRopeSegment.collision_layer = 1
			newRopeSegment.collision_mask = 2
		else:
			newRopeSegment.collision_layer = 1
			newRopeSegment.collision_mask = 2
		pos = Vector2(pos.x + ropeSegmentWidth/2, pos.y) if i == 0 else Vector2(pos.x + ropeSegmentWidth, pos.y)
		newRopeSegment.position = Vector2(pos.x, pos.y)
		
		parent.add_child(newRopeSegment)
		joint.node_a = newRopeSegment.get_path()
		print(joint.node_a)
		tail = newRopeSegment
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
