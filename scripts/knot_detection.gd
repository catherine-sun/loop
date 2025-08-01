extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detect_knot({})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var allPermutations = {
	"1": [["1"]],
	"2": [
		["1", "2"],
		["2", "1"]
	],
	"3": [
		["1", "2", "3"],
		["1", "3", "2"],
		["2", "1", "3"],
		["2", "3", "1"],
		["3", "1", "2"],
		["3", "2", "1"]
	],
	"4": [
		["1", "2", "3", "4"],
		["1", "2", "4", "3"],
		["1", "3", "2", "4"],
		["1", "3", "4", "2"],
		["1", "4", "2", "3"],
		["1", "4", "3", "2"],
		["2", "1", "3", "4"],
		["2", "1", "4", "3"],
		["2", "3", "1", "4"],
		["2", "3", "4", "1"],
		["2", "4", "1", "3"],
		["2", "4", "3", "1"],
		["3", "1", "2", "4"],
		["3", "1", "4", "2"],
		["3", "2", "1", "4"],
		["3", "2", "4", "1"],
		["3", "4", "1", "2"],
		["3", "4", "2", "1"],
		["4", "1", "2", "3"],
		["4", "1", "3", "2"],
		["4", "2", "1", "3"],
		["4", "2", "3", "1"],
		["4", "3", "1", "2"],
		["4", "3", "2", "1"]
	]
}

"""
takes in input like:
{
	"1": [
		{ "rope": 2, "position": "over" },
		{ "rope": 2, "position": "over" }
	],
	"2": [
		{ "rope": 3, "position": "over" },
		{ "rope": 3, "position": "under" }
	],
	"3": [
		{ "rope": 1, "position": "over" },
		{ "rope": 1, "position": "under" }
	]
	
}
	
	
"""

var knot =  {
  "numRopes": 3,
  "crosses": {
	"1": [
	  { "rope": "2", "position": "over" },
	  { "rope": "2", "position": "over" },
	  { "rope": "2", "position": "under" },
	  { "rope": "3", "position": "under" },
	  { "rope": "3", "position": "over" }
	],
	"2": [
	  { "rope": "3", "position": "over" },
	  { "rope": "3", "position": "under" },
	  { "rope": "1", "position": "under" },
	  { "rope": "1", "position": "over" }
	],
	"3": [
	  { "rope": "1", "position": "over" },
	  { "rope": "1", "position": "under" },
	  { "rope": "2", "position": "under" },
	  { "rope": "2", "position": "over" }
	]
  }
}
	
func detect_knot(intersections):
	var temp = {
	"1": [
	  { "rope": "2", "position": "over" },
	  { "rope": "2", "position": "over" },
	  { "rope": "2", "position": "under" },
	  { "rope": "3", "position": "under" },
	  { "rope": "3", "position": "over" }
	],
	"2": [
	  { "rope": "3", "position": "over" },
	  { "rope": "3", "position": "under" },
	  { "rope": "1", "position": "under" },
	  { "rope": "1", "position": "over" }
	],
	"3": [
	  { "rope": "1", "position": "over" },
	  { "rope": "1", "position": "under" },
	  { "rope": "2", "position": "under" },
	  { "rope": "2", "position": "over" }
	]
		
	}
	
	var temp2 = { 
		"1": [
  { "rope": "3", "position": "over" },
  { "rope": "3", "position": "over" },
  { "rope": "3", "position": "under" },
  { "rope": "2", "position": "under" },
  { "rope": "2", "position": "over" }
],
"3": [
  { "rope": "2", "position": "over" },
  { "rope": "2", "position": "under" },
  { "rope": "1", "position": "under" },
  { "rope": "1", "position": "over" }
],
"2": [
  { "rope": "1", "position": "over" },
  { "rope": "1", "position": "under" },
  { "rope": "3", "position": "under" },
  { "rope": "3", "position": "over" }
]
		}
	var numRopes = knot["numRopes"]
	var crosses = knot["crosses"]
	
	
	var origRopeKeys = range(1, numRopes + 1).map(func(x): return str(x))
	
	var isKnot = false
	for permutation in allPermutations[str(numRopes)]:
		var ropeKeyAssignment = permutationToKeyAssignment(permutation, origRopeKeys)
		if (isRopeMatch(ropeKeyAssignment, temp2, crosses, origRopeKeys)):
			print("YAY MATCH!")
			isKnot = true
			break
	
	if (isKnot):
		print("YAY KNOT")
	else:
		print(":( not a knot")
		
	return isKnot
	
func permutationToKeyAssignment(p, orig):
	var l = len(p)
	var h = {}
	for i in range(l):
		h[orig[i]] = p[i]
		
	return h
		
func isRopeMatch(ropeKeyAssignment, crosses, correctCrosses, ropeKeys):
	print(ropeKeyAssignment)
	print(crosses)
	print(correctCrosses)
	print(ropeKeys)
	for ropeKey in ropeKeys:
		var crossList = crosses[ropeKeyAssignment[ropeKey]]
		var correctCrossList = correctCrosses[ropeKey]
		if (len(crossList) == len(correctCrossList)):
			for i in range(len(crossList)):
				if (ropeKeyAssignment[crossList[i]["rope"]] == correctCrossList[i]["rope"] and (crossList[i]["position"] == correctCrossList[i]["position"])):
					print("Matched " + str(correctCrossList[i]))
					return true
				else:
					print("NOT A MATCH, got " + str(crossList[i]) + " when comparing it with " + str(correctCrossList[i]))
					return false
	return false 	
