extends Node

@export var extents: float
@export var numPlanets: int
@export var minDist: float
var planet =  preload("res://Planets/planet.tscn")

var points = []
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(numPlanets):
		var x = rng.randf_range(-extents, extents)
		var y = rng.randf_range(-extents, extents)
		var point = Vector2(x, y)
		points.append(point)
		
	var toRemove = []
	var i = 0
	while i < points.size():
		var popped = 0
		for j in range(points.size()-1, 0, -1):
			if j < i:
				if points[i-popped].distance_to(points[j]) < minDist:
					points.pop_at(j)
					popped += 1
			else:
				if i != j and points[i].distance_to(points[j]) < minDist:
					points.pop_at(j)
		i += 1
		
	for p in points:
		var instance = planet.instantiate()
		instance.position = p
		add_child(instance)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
