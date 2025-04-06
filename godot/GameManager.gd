extends Node
class_name GameManagerClass

enum Chem { ChemO, ChemH, ChemC, ChemN }

signal gravity_target(target: GravityCenter)
signal on_collectible(chemicals: CollectibleResource)

var collectibles_on_ship = {}
var collectibles_on_earth = {}

func _ready() -> void:
	for chem in Chem.values():
		collectibles_on_ship[chem] = 0
	on_collectible.connect(_on_collectible)

func _on_collectible(chemicals: CollectibleResource) -> void:
	for i in chemicals.get_chems().keys():
		if i in collectibles_on_ship:
			collectibles_on_ship[i] += chemicals.chemicals[i]
		else:
			collectibles_on_ship[i] = chemicals.chemicals[i]
		
	print("collectible %s" % collectibles_on_ship)
