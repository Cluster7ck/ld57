extends Node

@export var extents: float
@export var numPlanets: int
@export var minDistPlanets: float
@export var minDistCollectibles: float
@export var collectibleChance: float

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var planets = []
	var planet_variants_path = "res://Planets/variants/"
	for planet in ResourceLoader.list_directory(planet_variants_path):
		if planet.ends_with(".tscn"):
			var path = planet_variants_path + planet
			var planet_scene = ResourceLoader.load(path)
			planets.append(planet_scene)
			
	var collectibles = []
	var chem_varaints_path = "res://Collectibles/"
	for chem in ResourceLoader.list_directory(chem_varaints_path):
		if chem.begins_with("chem") and chem.ends_with(".tscn"):
			var path = chem_varaints_path +  chem
			var chem_scene = ResourceLoader.load(path)
			collectibles.append(chem_scene)
	
	var planetPoints = []
	var collectiblePoints = []
	for i in range(numPlanets):
		var x = rng.randf_range(-extents, extents)
		var y = rng.randf_range(-extents, extents)
		var point = Vector2(x, y)
		planetPoints.append(point)
		
	var i = 0
	while i < planetPoints.size():
		var popped = 0
		for j in range(planetPoints.size()-1, 0, -1):
			if j < i:
				var dist = planetPoints[i-popped].distance_to(planetPoints[j])
				if dist < minDistCollectibles:
					planetPoints.pop_at(j)
					popped += 1
				elif dist < minDistPlanets:
					if(rng.randf() > collectibleChance):
						collectiblePoints.append(planetPoints[j])
					planetPoints.pop_at(j)
					popped += 1
			else:
				if i == j:
					continue
				var dist = planetPoints[i].distance_to(planetPoints[j])
				if dist < minDistCollectibles:
					planetPoints.pop_at(j)
				elif dist < minDistPlanets:
					if(rng.randf() > collectibleChance):
						collectiblePoints.append(planetPoints[j])
					planetPoints.pop_at(j)
		i += 1
		
	for p in planetPoints:
		var planet = planets[floor(rng.randf_range(0, planets.size()))]
		var instance = planet.instantiate()
		instance.position = p
		add_child(instance)
		
	for p in collectiblePoints:
		var collectible = collectibles[floor(rng.randf_range(0, collectibles.size()))]
		var instance = collectible.instantiate()
		instance.position = p
		add_child(instance)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
