extends Node2D

@export var ropeCount: int
@export var ropeLength: int
@export var ropeSegmentWidth: int
@export var jointStiffness: float
@export var maxSegments: int

const ROPE_SEGMENT = preload("res://components/rope/rope_segment.tscn")
const ROPE_END_SEGMENT = preload("res://components/rope/rope_end.tscn")

var ropeHolders = []
var ropeContainers = []
var ropeGeneratedSegments = []

var ropes = []
const ROPE_END = preload("res://components/rope/rope_end.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	addRopes(ropeCount) # Replace with function body.

func addRopes(numRopes):
	for i in range(numRopes):
		var ropeContainer = Node2D.new()
		add_child(ropeContainer)
		var newPath = Path2D.new()
		var newPathFollow = PathFollow2D.new()
		ropes.append({ 
			"parent": ropeContainer, 
			"holderJoint": null,
			"segments": [],
			"joints": [],
			"path": newPath,
			"pathFollow": newPathFollow
		})
		ropeContainer.add_child(newPath)
		newPath.add_child(newPathFollow)
		addRopeSegments(newPath)
		ropeContainer.rotate(i * 0.1)
		ropeContainers.append(ropeContainer)
		ropeGeneratedSegments.append(0)
		

func addNewSegment(flag, dir):
	if ropes[flag]["segments"].size() > maxSegments:
		return
	var parent = ropes[flag]["parent"]
	var ropeHolderJoint = ropes[flag]["holderJoint"]
  
	var joint = PinJoint2D.new()
	parent.add_child(joint)

	joint.position = Vector2($RopeHolder.position.x,ropeHolderJoint.position.y)
	var joint2 = PinJoint2D.new()
	parent.add_child(joint2)

	joint2.position = Vector2(ropeHolderJoint.position.x + ropeSegmentWidth/2, ropeHolderJoint.position.y)
	var prevRootSegment = ropeHolderJoint.node_b
	joint.node_b = prevRootSegment
  
	var newRopeSegment = ROPE_SEGMENT.instantiate()
	parent.add_child(newRopeSegment)

	newRopeSegment.collision_layer = 1
	newRopeSegment.collision_mask = 2
	newRopeSegment.position = Vector2($RopeHolder.position.x + ropeSegmentWidth * 0.5, ropeHolderJoint.position.y)
	joint.node_a = newRopeSegment.get_path()

	joint2.node_b = newRopeSegment.get_path()
	var newRopeSegment2 = ROPE_SEGMENT.instantiate()
	parent.add_child(newRopeSegment2)

	newRopeSegment2.collision_layer = 1
	newRopeSegment2.collision_mask = 2
	newRopeSegment2.position = Vector2($RopeHolder.position.x + ropeSegmentWidth * 0.5, ropeHolderJoint.position.y)
	joint2.node_a = newRopeSegment2.get_path()
	ropeHolderJoint.node_b = newRopeSegment2.get_path()
	ropeHolderJoint.node_a = $RopeHolder.get_path()

	var distance_factor = 0
	joint.softness = jointStiffness * (distance_factor * 1.5)
	distance_factor = 0
	joint2.softness = jointStiffness * (distance_factor * 1.5)

	
	ropeGeneratedSegments[flag] += 2
	
	ropes[flag]["joints"].insert(1, joint)
	ropes[flag]["joints"].insert(1, joint2)

	ropes[flag]["segments"].insert(1, newRopeSegment)
	ropes[flag]["segments"].insert(1, newRopeSegment2)

func addRopeSegments(parent):
	var idx = ropes.size() - 1
	var holder = $RopeHolder
	var previousSegment = holder
	var pos = Vector2(holder.position.x, holder.position.y)

	for i in range(ropeLength):
		var joint = PinJoint2D.new()
		joint.position = Vector2(pos.x + ropeSegmentWidth * 0.5, pos.y)
		parent.add_child(joint)
			
		var newRopeSegment
		if i == 0:
			ropes[idx]["holderJoint"] = joint
		if i == ropeLength - 1:
			newRopeSegment = ROPE_END.instantiate()
			newRopeSegment.setId(ropeHolders.size()-1)
			newRopeSegment.connect("new_segment_please", addNewSegment)
		else:
			newRopeSegment = ROPE_SEGMENT.instantiate()

		newRopeSegment.collision_layer = 1
		newRopeSegment.collision_mask = 2

		pos = Vector2(pos.x + ropeSegmentWidth, pos.y)
		newRopeSegment.position = pos
		parent.add_child(newRopeSegment)

		joint.node_a = previousSegment.get_path()
		if (i < ropeLength - 1):
			joint.node_b = newRopeSegment.get_path()

		#var distance_factor = float(i) / float(ropeLength - 1)
		#joint.softness = jointStiffness * (distance_factor * 1.5)
		#joint.bias = 0.9 - distance_factor * 0.3

		previousSegment = newRopeSegment
		
		ropes[idx]["joints"].append(joint)
		ropes[idx]["segments"].append(newRopeSegment)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	for rope in ropes:
		var end = rope["segments"][len(rope["segments"]) - 1]
		var path = rope["path"]
		var curve = path.curve
		var new_position = end.global_position
		
		if curve == null:
			curve = Curve2D.new()
			path.curve = curve
		
		var point_count = curve.get_point_count()
		
		if end.isDragging():
			if point_count == 0:
				# If this is the first point, just add it
				curve.add_point(new_position)
			else:
				var lastPoint = curve.get_point_position(point_count - 1)
				#print("Last point")
				#print(lastPoint)
				#print(new_position)
				#print(lastPoint.distance_to(new_position))
				if (lastPoint.distance_to(new_position) > 10):
					# Add point at the end
					curve.add_point(new_position)
				else:
					break
	
		# move all other segments along path
		var segments = rope["segments"]
		for i in range(segments.size()-1):
			var segment = segments[i]
			var dist = i * ropeSegmentWidth
			var pt = curve.sample_baked(dist)
			
			print("Pt is " + str(pt) + "  " + str(dist) + "  " + str(curve.get_baked_length()) + " " + str(segments[i].position))
			var dir = pt - segment.position
			var strength = 1000
			var force = dir.normalized() * strength  # tune strength
			if (pt.distance_to(segment.position) > 10):
				var cur_pt = path.to_global(curve.sample_baked(dist))
				var next_pt = path.to_global(curve.sample_baked(min(dist + ropeSegmentWidth, curve.get_baked_length())))
				segment.position = pt
				var angle = (next_pt - cur_pt).normalized().angle()
				var deg = rad_to_deg(angle)
				# Position
				segment.position = pt


				# Normalize to avoid upside-down flipping
				var flipped = false
				if angle > PI / 2:
					angle -= PI
					flipped = true
				elif angle < -PI / 2:
					angle += PI
					flipped = true

				segment.rotation = angle + 90
		
	
