extends Node
class_name GameManagerClass

enum Chem { ChemO, ChemH, ChemC, ChemN }

signal gravity_target(target: GravityCenter)
signal on_collectible(chemicals: CollectibleResource)

var collectibles_on_ship = {}
var collectibles_on_earth = {}
var attached_to_earth = false
var gravity_center: GravityCenter = null
var drain_rate = 5
var ship: Node2D

func _ready() -> void:
	for chem in Chem.values():
		collectibles_on_ship[chem] = 0
	on_collectible.connect(_on_collectible)
	gravity_target.connect(_on_gravity_target)
	
func _on_gravity_target(target: GravityCenter) -> void:
	if target and target.name == "Erde":
		attached_to_earth = true
		gravity_center = target
		var max_collectibles = - 1
		for i in collectibles_on_ship.keys():
			if collectibles_on_ship[i] > max_collectibles:
				max_collectibles = collectibles_on_ship[i]
		# calculate drain_rate so that everything is drained in 3 seconds
		drain_rate = max_collectibles / 3
	elif target and target.drainFrom:
		drain_rate = 5
		gravity_center = target
	else:
		attached_to_earth = false
		gravity_center = null
		drain_rate = 5
		
func set_ship(the_ship: Node2D) -> void:
	ship = the_ship
		
func _on_collectible(chemicals: CollectibleResource) -> void:
	for i in chemicals.get_chems().keys():
		if i in collectibles_on_ship:
			collectibles_on_ship[i] += chemicals.chemicals[i]
		else:
			collectibles_on_ship[i] = chemicals.chemicals[i]

func _physics_process(delta: float) -> void:
	if attached_to_earth:
		var velocity = ship.velocity
		ship.velocity = velocity.limit_length(velocity.length() * 0.99)
			
func _process(delta: float) -> void:
	if attached_to_earth:
		var dist = (gravity_center.position - ship.position).length()
		if dist < gravity_center.get_real_size() + 1000:
			for i in collectibles_on_ship.keys():
				if collectibles_on_ship[i] > 0:
					# drain at rate of 5 per second
					var drain = drain_rate * delta
					if (collectibles_on_ship[i] - drain) < 0:
						drain = collectibles_on_ship[i]
					collectibles_on_ship[i] -= drain
					collectibles_on_earth[i] = collectibles_on_earth.get(i, 0) + drain
	elif gravity_center:
		var dist = (gravity_center.position - ship.position).length()
		
		if dist < gravity_center.get_real_size() + 1000:
			var collectibles = gravity_center.collectibles.get_chems()
			
			for i in collectibles.keys():
				if collectibles[i] > 0:
					# drain at rate of 5 per second
					var drain = drain_rate * delta
					if collectibles_on_ship[i] < 0:
						drain = collectibles[i]
					collectibles[i] -= drain
					collectibles_on_ship[i] = collectibles_on_ship.get(i, 0) + drain
			#print(collectibles_on_ship)
	pass
