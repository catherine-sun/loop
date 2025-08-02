extends Node2D

@export var ropeLength: int
@export var ropeSegmentWidth: int

const ROPE_SEGMENT = preload("res://components/rope/rope_segment.tscn")
const ROPE_END_SEGMENT = preload("res://components/rope/rope_end.tscn")

var ropeHolders = []
var ropeContainers = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	addRopes(1) # Replace with function body.
	
func addRopes(numRopes):
	for i in range(numRopes):
		var ropeContainer = Node2D.new()
		add_child(ropeContainer)
		addRopeSegments(ropeContainer)
		ropeContainer.rotate(i * 0.1)
		ropeContainers.append(ropeContainer)
		
func addNewSegment(flag):
	var parent = ropeContainers[flag]
	print("Called add new segment " + str(flag))
	var ropeHolderJoint = ropeHolders[flag]
	var joint = PinJoint2D.new()
	joint.position = Vector2($RopeHolder.position.x,$RopeHolder.position.y)
	var joint2 = PinJoint2D.new()
	joint2.position = Vector2(ropeHolderJoint.position.x + ropeSegmentWidth, ropeHolderJoint.position.y)
	parent.add_child(joint)
	joint.node_b = ropeHolderJoint.node_a
	var newRopeSegment = ROPE_SEGMENT.instantiate()
	parent.add_child(newRopeSegment)
	newRopeSegment.collision_layer = 1
	newRopeSegment.collision_mask = 2
	newRopeSegment.position = Vector2($RopeHolder.position.x + ropeSegmentWidth/2, $RopeHolder.position.y)
	ropeContainers[flag].add_child(newRopeSegment)
	joint.node_a = newRopeSegment.get_path()
	
	joint2.node_b = newRopeSegment.get_path()
	var newRopeSegment2 = ROPE_SEGMENT.instantiate()
	newRopeSegment2.collision_layer = 1
	newRopeSegment2.collision_mask = 2
	newRopeSegment2.position = Vector2($RopeHolder.position.x + ropeSegmentWidth/2, $RopeHolder.position.y)
	parent.add_child(newRopeSegment2)
	parent.add_child(joint2)

	joint2.node_a = newRopeSegment2.get_path()
	print(joint.node_a)
	ropeHolderJoint.node_a = newRopeSegment2.get_path()
		
func addRopeSegments(parent):
	var head = $RopeHolder
	var tail =  $RopeHolder
	var pos = Vector2($RopeHolder.position.x, $RopeHolder.position.y)
	for i in range(ropeLength):
		print(pos)
		var joint = PinJoint2D.new()
		if (i == 0):
			ropeHolders.append(joint)
		joint.position = pos if i == 0 else Vector2(pos.x + ropeSegmentWidth/2, pos.y)
		parent.add_child(joint)
		joint.node_b = tail.get_path()
		var newRopeSegment = ROPE_SEGMENT.instantiate() if i < ropeLength - 1 else ROPE_END_SEGMENT.instantiate()
		newRopeSegment.collision_layer = 1
		newRopeSegment.collision_mask = 2
		pos = Vector2(pos.x + ropeSegmentWidth/2, pos.y) if i == 0 else Vector2(pos.x + ropeSegmentWidth, pos.y)
		newRopeSegment.position = Vector2(pos.x, pos.y)
		parent.add_child(newRopeSegment)
		joint.node_a = newRopeSegment.get_path()
		print(joint.node_a)
		tail = newRopeSegment
		
		if i == ropeLength - 1:
			newRopeSegment.setId(ropeHolders.size()-1)
			newRopeSegment.connect("new_segment_please", addNewSegment)

	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
