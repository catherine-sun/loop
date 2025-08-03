extends Node

var currentLevel = null
var knotsToDetect = []
var allKnots = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	allKnots = read_json_file("res://data/knots.json")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentLevel != null:
		detectLevelOver()
	pass
	
func startLevel(level):
	get_tree().change_scene_to_file(level["scene"])
	currentLevel = level
	knotsToDetect = [allKnots[level["knot"]]]
	RopeManager.init(range(1, level["numRopes"] + 1).map(func(x): return str(int(x))))
	print("For knot we need")
	print(knotsToDetect)
	await get_tree().create_timer(1.0).timeout
	print("Fired after 2 seconds")
	for n in get_tree().get_nodes_in_group("protec"):
		print(n, "I s a protec zone")
		n.toggleSegments()
	
func endLevel():
	currentLevel = null
	knotsToDetect = []
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func detectLevelOver():
	var intersections = RopeManager.formatCrossesForKnotDetection()
	for knot in knotsToDetect:
		var isKnot = KnotDetection.detect_knot(intersections, knot)
		if isKnot:
			print("WE CREATED A KNOT")
			endLevel()


func read_json_file(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		var result = JSON.parse_string(text)
		if typeof(result) == TYPE_DICTIONARY:
			return result
		else:
			push_error("JSON is not a dictionary")
	else:
		push_error("Failed to open file: " + path)
	return {}
