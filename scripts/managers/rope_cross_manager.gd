extends Node

signal rope_collision(collider, body)
signal rope_collision_exit(collider, body)

var crosses = {}
var isActive = false
var adjacentSegmentLength = 4

var adjacentSteps = range(-adjacentSegmentLength, adjacentSegmentLength+1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("rope_collision", _on_global_rope_collision)
	connect("rope_collision_exit", _on_global_rope_collision_exit)

	init(["1", "2", "3"])

func _on_global_rope_collision(collider, body):
	if !isActive:
		return
		
	if "RopeSegment" in collider.name and body is RigidBody2D:
		if !collider.getLeftFeeder() or !body.getLeftFeeder():
			return

		var colliderId = collider.getRopeIds()
		var bodyId = body.getRopeIds()
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
		var colliderId = collider.getRopeIds()
		var bodyId = body.getRopeIds()
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
	
func isInACross(ropeId):
	return crosses[ropeId["ropeId"]].any(func(x): return x["segment"]["segmentId"] == ropeId["segmentId"])
	
	
func formatCrossesForKnotDetection():
	var obj = {}
	for ropeId in crosses.keys():
		var crossList = []
		crosses[ropeId].sort_custom(func(a,b): a["segment"]["segmentId"] < b["segment"]["segmentId"])
		var crossesForRope = crosses[ropeId]

		for cross in crossesForRope:
			crossList.append({ "rope": cross["collider"]["ropeId"], "position": "over" })
		obj[ropeId] = crossList
	return obj
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
