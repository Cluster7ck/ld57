class_name RandomPlanetSpritePicker
extends Sprite2D


var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var planet_sprite_paths: Array = []
	var planet_sprite_variants_path = "res://Planets/PlanetSprites/"
	for planet_sprite in ResourceLoader.list_directory(planet_sprite_variants_path):
		if planet_sprite.ends_with(".png"):
			var path = planet_sprite_variants_path + planet_sprite
			planet_sprite_paths.append(path)
	
	texture = load(planet_sprite_paths[rng.randi_range(0, planet_sprite_paths.size()-1)])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
