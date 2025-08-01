extends Node2D

@export var ropeCount: int
@export var ropeLength: int
@export var ropeSegmentWidth: int
@export var jointStiffness: float

const ROPE_SEGMENT = preload("res://components/rope/rope_segment.tscn")
const ROPE_END = preload("res://components/rope/rope_end.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	addRopes(ropeCount) # Replace with function body.

func addRopes(numRopes):
	for i in range(numRopes):
		var ropeContainer = Node2D.new()
		add_child(ropeContainer)
		addRopeSegments(ropeContainer)
		ropeContainer.rotate(i * 0.1)

func addRopeSegments(parent):
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
		else:
			newRopeSegment = ROPE_SEGMENT.instantiate()

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
