extends Node
class_name GameManagerClass

enum Chem { ChemO, ChemH, ChemC, ChemN }

signal gravity_target(position)
signal on_collectible(chemicals: CollectibleResource)

var collectibles = {}

func _ready() -> void:
	for chem in Chem.values():
		collectibles[chem] = 0
	on_collectible.connect(_on_collectible)

func _on_collectible(chemicals: CollectibleResource) -> void:
	for i in chemicals.get_chems().keys():
		if i in collectibles:
			collectibles[i] += chemicals.chemicals[i]
		else:
			collectibles[i] = chemicals.chemicals[i]
		
	print("collectible %s" % collectibles)
