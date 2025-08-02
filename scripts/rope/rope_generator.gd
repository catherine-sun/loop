extends Node2D

@export var ropeCount: int
@export var ropeLength: int
@export var ropeSegmentWidth: int
@export var jointStiffness: float
@export var ropeId: String

const ROPE_SEGMENT = preload("res://components/rope/rope_segment.tscn")
const ROPE_END = preload("res://components/rope/rope_end.tscn")

var ropes = []

var overlappingBodies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	addRopes(ropeCount) # Replace with function body.
	$RopeHolder.collision_layer = 1
	$RopeHolder.collision_mask = 2

func addRopes(numRopes):
	for i in range(numRopes):
		var ropeContainer = Node2D.new()
		add_child(ropeContainer)
		var newRopeObj = {
			"parent": ropeContainer,
			"joints": [],
			"segments": [],
			"crosses": [],
			"end": null,
			"currentCross": null,
			"ropeId": ropeId
		}
		ropes.append(newRopeObj)
		addRopeSegments(newRopeObj)
		ropeContainer.rotate(i * 0.1)

func addRopeSegments(rope):
	var parent = rope["parent"]
	var holder = $RopeHolder
	var previousSegment = holder
	var pos = Vector2(holder.position.x, holder.position.y)

	for i in range(ropeLength):
		var joint = PinJoint2D.new()
		joint.position = Vector2(pos.x + ropeSegmentWidth * 0.5, pos.y)
		parent.add_child(joint)
		
		var newRopeSegment
		if i == ropeLength - 1:
			newRopeSegment = ROPE_END.instantiate()
			rope["end"] = newRopeSegment
		else:
			newRopeSegment = ROPE_SEGMENT.instantiate()
			newRopeSegment.name = "RopeSegment" + str(i)
			rope["segments"].append(newRopeSegment)
			newRopeSegment.setRopeIds({
				"ropeId": ropeId,
				"segmentId": i
			})


		newRopeSegment.collision_layer = 1
		newRopeSegment.collision_mask = 2

		pos = Vector2(pos.x + ropeSegmentWidth, pos.y)
		newRopeSegment.position = pos
		parent.add_child(newRopeSegment)

		joint.node_a = previousSegment.get_path()
		joint.node_b = newRopeSegment.get_path()

		var distance_factor = float(i) / float(ropeLength - 1)
		joint.softness = jointStiffness * (distance_factor * 1.5)
		joint.bias = 0.9 - distance_factor * 0.3

		previousSegment = newRopeSegment
		
		rope["joints"].append(joint)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(getOverlappingRopes())
	pass
	
func getOverlappingRopes():
	if len(ropes) > 0:
		var overlappingRopes = []
		var rope = ropes[0]
		var prevSegment = null
		var nextSegment = null
		var segments = rope["segments"]
		var numSegments = segments.size()
		
		for i in range(numSegments):
			nextSegment = segments[i+1] if i < numSegments - 1 else null
			prevSegment = segments[i-1] if i > 0 else null 
			var segment = segments[i]
			var segmentOverlappingNodes = segment.get_node("Area2D").get_overlapping_bodies().map(func(n): return n.getId()["ropeId"] if "RopeSegment" in n.name and (n.getId()["ropeId"] != segment.getId()["ropeId"] or abs(n.getId()["segmentId"] - segment.getId()["segmentId"]) > 2) else null)
			segmentOverlappingNodes = segmentOverlappingNodes.filter(func(x): return x != null and x != "")
			overlappingRopes = overlappingRopes + segmentOverlappingNodes.filter(func(x): return x != null and x != "")
		return overlappingRopes
	return []
		
