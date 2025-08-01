extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



"""
Takes in a list of intersections for each rope in the following format:
	[
		[
			{
				"rope": rope2",
				"position": "under"
			},
			{
				"rope": rope2",
				"position": "over"
			},
		]
	]
"""

var knot = 
func check_for_knot(intersections):
	
	
