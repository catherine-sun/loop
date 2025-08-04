extends Node

var LEVEL_COMPLETE = preload("res://components/ui/level_complete.tscn")

var levels = []
var currentLevel = null
var knotsToDetect = []
var allKnots = {}
var currentLevelIndex = 0
var unlockedLevels = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	allKnots = read_json_file("res://data/knots.json")
	levels = read_json_file("res://data/levels.json")
	for i in range(len(levels["levels"])):
		levels["levels"][i]["number"] = str(int(i+1))
	unlockedLevels = [levels["levels"][0].name]

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentLevel != null:
		detectLevelOver()
	pass
	
func getLevels():
	return levels
	
func getCurrentLevel():
	return currentLevel

func startLevel(level):
	currentLevel = level
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	knotsToDetect = [allKnots[level["knot"]]]
	RopeManager.init(range(1, level["numRopes"] + 1).map(func(x): return str(int(x))))
	print("For knot we need")
	print(knotsToDetect)
	await get_tree().create_timer(1.0).timeout
	print("Fired after 2 seconds")
	for n in get_tree().get_nodes_in_group("protec"):
		print(n, "I s a protec zone")
		n.toggleSegments()
	
var completeScreen = LEVEL_COMPLETE.instantiate()
func endLevel():
	currentLevel = null
	knotsToDetect = []
	RopeManager.pause()
	#get_tree().change_scene_to_packed(LEVEL_COMPLETE)
	
func detectLevelOver():
	var intersections = RopeManager.formatCrossesForKnotDetection()
	for knot in knotsToDetect:
		var isKnot = KnotDetection.detect_knot(intersections, knot)
		if isKnot:
			print("WE CREATED A KNOT")
			unlockedLevels.append(levels["levels"][currentLevelIndex + 1].name)
			get_tree().root.add_child(completeScreen)
			completeScreen.setKnotName(currentLevel["name"])
			endLevel()

func removeLevelComplete():
	get_tree().root.remove_child(completeScreen)

func setLevels(l):
	levels = l
	unlockedLevels = [l[0].name]

func getUnlockedLevels():
	return unlockedLevels	
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
