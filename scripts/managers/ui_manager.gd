extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var objMags = {}
func handleScale(node, min, max, delta, speed, cycle=true):
	if (node not in objMags):
		objMags[node] = 1
	if node.scale.x >= max.x or node.scale.y >= max.y:
		objMags[node] = -1 if cycle else 1
	elif node.scale.x <= min.x or node.scale.y <= min.y:
		objMags[node] = 1
		
	var t = (node.scale.x - min.x) / (max.x - min.x)
	var ease = sin(t * PI) # smooth in/out
	var step = clamp(10 * speed * delta * (1 - ease), speed * 0.1, speed * 1.1)* objMags[node]
	node.scale = Vector2(clamp(node.scale.x + step , min.x, max.x), clamp(node.scale.y + step , min.y, max.y))
	

func handleScaleOnce(node, min, max, delta, speed):
	if (node not in objMags):
		objMags[node] = 1
	elif node.scale.x <= min.x or node.scale.y <= min.y:
		objMags[node] = 1
		
	var t = (node.scale.x - min.x) / (max.x - min.x)
	var ease = sin(t * PI) # smooth in/out
	var step = clamp(10 * speed * delta * (1 - ease), speed * 0.1, speed * 1.1)* objMags[node]
	node.scale = Vector2(clamp(node.scale.x + step , min.x, max.x), clamp(node.scale.y + step , min.y, max.y))
	
