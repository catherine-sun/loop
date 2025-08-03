extends Node

signal rope_collision(collider, body)
signal rope_collision_exit(collider, body)

var crosses = {}
var isActive = false
var adjacentSegmentLength = 4
var ropes = {}
var hovered_segments = {}

var adjacentSteps = range(-adjacentSegmentLength, adjacentSegmentLength+1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("rope_collision", _on_global_rope_collision)
	connect("rope_collision_exit", _on_global_rope_collision_exit)

	init(["1", "2", "3"])

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Q and hovered_segments.size() > 0:
			for key in hovered_segments.keys():
				var segment = hovered_segments[key]
				if segment and not segment.is_normal_state():
					print("Q pressed on segment: ", segment.rope_id, " segment ", segment.segment_id)
					segment.toggle_lock()

func set_hovered_segment(segment):
	var key = str(segment.rope_id) + "_" + str(segment.segment_id)
	hovered_segments[key] = segment

func clear_hovered_segment(segment):
	var key = str(segment.rope_id) + "_" + str(segment.segment_id)
	if hovered_segments.has(key):
		hovered_segments.erase(key)

func _on_global_rope_collision(collider, body):
	if !isActive:
		return

	if "RopeSegment" in collider.name and body is RigidBody2D:
		if !collider.getLeftFeeder() or !body.getLeftFeeder():
			return

		var colliderId = {"ropeId": collider.rope_id, "segmentId": collider.segment_id}
		var bodyId = {"ropeId": body.rope_id, "segmentId": body.segment_id}
		var idToAdd = colliderId["ropeId"] if shouldWeAddThisCross(colliderId, bodyId) else null
		if idToAdd != null:
			crosses[bodyId["ropeId"]].append({ "collider": colliderId, "segment": bodyId })


# TODO: idk why this doesnt work
func shouldWeAddThisCross(colliderId, bodyId):

	if (colliderId["ropeId"] == bodyId["ropeId"] and abs(colliderId["segmentId"] - bodyId["segmentId"]) < adjacentSegmentLength):
		return false
	for cross in crosses[bodyId["ropeId"]]:
		var toCompareColliders = adjacentSteps.map(func(x): return adjacentSegment(colliderId, x))
		var toCompareSegments = adjacentSteps.map(func(x): return adjacentSegment(bodyId, x))
		for col in toCompareColliders:
			for seg in toCompareSegments:
				if (compareRopeIds(col, cross["collider"]) and compareRopeIds(seg, cross["segment"])):
					return false
	return true

func adjacentSegment(bodyId, step):
	return { "ropeId": bodyId["ropeId"], "segmentId": bodyId["segmentId"] + step }

func _on_global_rope_collision_exit(collider, body):
	if !isActive:
		return

	if "RopeSegment" in collider.name:
		var colliderId = {"ropeId": collider.rope_id, "segmentId": collider.segment_id}
		var bodyId = {"ropeId": body.rope_id, "segmentId": body.segment_id}
		var idToAdd = colliderId["ropeId"]
		if idToAdd:
			crosses[bodyId["ropeId"]] = crosses[bodyId["ropeId"]].filter(func(x): return !compareRopeIds(x["collider"], colliderId) or !compareRopeIds(x["segment"], bodyId))

func comparePairs(a, b):
	return compareRopeIds(a["collider"], b["collider"]) and compareRopeIds(a["segment"], b["segment"])

func compareRopeIds(a, b):
	return a["ropeId"] == b["ropeId"] and a["segmentId"] == b["segmentId"]

func init(ropeIds):
	crosses = {}
	for i in ropeIds:
		crosses[i] = []
	isActive = true

func pause():
	isActive = false
	
func isInACross(rope_id, segment):
	if crosses.has(rope_id):
		return crosses[rope_id].any(func(x): return x["segment"]["segmentId"] == segment.segment_id)
	return false
	
	

func formatCrossesForKnotDetection():
	var obj = {}
	for ropeId in crosses.keys():
		var crossList = []
		var crossesForRope = crosses[ropeId]
		crossesForRope.sort_custom(func(a,b): return a["segment"]["segmentId"] < b["segment"]["segmentId"])

		for cross in crossesForRope:
			crossList.append({ "rope": cross["collider"]["ropeId"], "position": "over" })
		obj[ropeId] = crossList
	return obj

func getOverlappingRopes():
	if len(ropes) > 0:
		var overlappingRopes = []
		# Get the first rope from the dictionary
		var first_rope_id = ropes.keys()[0]
		var rope = ropes[first_rope_id]
		var _prevSegment = null
		var _nextSegment = null
		var segments = rope["segments"]
		var numSegments = segments.size()

		for i in range(numSegments):
			_nextSegment = segments[i+1] if i < numSegments - 1 else null
			_prevSegment = segments[i-1] if i > 0 else null
			var segment = segments[i]
			var segmentOverlappingNodes = segment.get_node("Area2D").get_overlapping_bodies().map(func(n): return n.rope_id if "RopeSegment" in n.name and (n.rope_id != segment.rope_id or abs(n.segment_id - segment.segment_id) > 2) else null)
			segmentOverlappingNodes = segmentOverlappingNodes.filter(func(x): return x != null and x != "")
			overlappingRopes = overlappingRopes + segmentOverlappingNodes.filter(func(x): return x != null and x != "")
		return overlappingRopes
	return []

func get_rope_count():
	return 3

func swap_rope_layers(rope_id: String, old: int, new: int):
	if old == new:
		return

	for other_id in ropes.keys():
		if other_id != rope_id and ropes[other_id]["layer"] == new:
			ropes[other_id]["layer"] = old
			var segments = ropes[other_id]["segments"]
			for i in range(segments.size() - 1, -1, -1):
				var segment = segments[i]
				if segment.has_method("is_physics_locked") and segment.is_physics_locked():
					break
				segment.get_node("Area2D").z_index = old
			if ropes[other_id]["end"]:
				ropes[other_id]["end"].z_index = old
			break

	if ropes.has(rope_id):
		ropes[rope_id]["layer"] = new
		var rope = ropes[rope_id]
		var segments = rope["segments"]
		for i in range(segments.size() - 1, -1, -1):
			var segment = segments[i]
			if segment.has_method("is_physics_locked") and segment.is_physics_locked():
				break
			segment.get_node("Area2D").z_index = new
		if rope["end"]:
			rope["end"].z_index = new
