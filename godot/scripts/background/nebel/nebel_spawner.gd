extends Node

@export var extents: float
@export var minDistFog: float
@export var numFogs: float
@export var fogPoints: float


var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fogs = []
	var fog_variants_path = "res://Scenes/background/nebel/"
	for fog in ResourceLoader.list_directory(fog_variants_path):
		if fog.ends_with(".tscn"):
			var path = fog_variants_path + fog
			var fog_scene = ResourceLoader.load(path)
			fogs.append(fog_scene)
			
	var fogPoints = []
	for i in range(numFogs):
		var x = rng.randf_range(-extents, extents)
		var y = rng.randf_range(-extents, extents)
		var point = Vector2(x, y)
		fogPoints.append(point)
		
	var toRemove = []
	var i = 0
	while i < fogPoints.size():
		var popped = 0
		for j in range(fogPoints.size()-1, 0, -1):
			if j < i:
				var dist = fogPoints[i-popped].distance_to(fogPoints[j])
				if dist < minDistFog:
					fogPoints.pop_at(j)
					popped += 1
			else:
				if i == j:
					continue
				var dist = fogPoints[i].distance_to(fogPoints[j])
				if dist < minDistFog:
					fogPoints.pop_at(j)
		i += 1
	
	
	for p in fogPoints:
		var fog = fogs[rng.randi_range(0, fogs.size()-1)]
		var instance = fog.instantiate()
		instance.position = p
		add_child(instance)
		instance.scale = Vector2(rng.randf_range(2, 3), rng.randf_range(2, 3))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
