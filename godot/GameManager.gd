extends Node
class_name GameManagerClass

enum Chem { ChemO, ChemH, ChemC, ChemN }

signal gravity_target(target: GravityCenter)
signal on_collectible(chemicals: CollectibleResource)

signal on_ship_collectibles(collectibles: Dictionary)
signal on_earth_collectibles(collectibles: Dictionary)


var collectibles_on_ship = { }
var stage = 0
var goals = [
	{
		# O2
		Chem.ChemO: 4,
		Chem.ChemC: 2,
		# H20
		Chem.ChemH: 8,
		Chem.ChemN: 0,
	},
	{
		# O2
		Chem.ChemO: 4,
		Chem.ChemC: 10,
		# H20
		Chem.ChemH: 2,
		Chem.ChemN: 0,
	},
	{
		# O2
		Chem.ChemO: 15,
		Chem.ChemC: 2,
		# H20
		Chem.ChemH: 2,
		Chem.ChemN: 0,
	}
]
var collectibles_on_earth = {}
var attached_to_earth = false
var gravity_center: GravityCenter = null
var drain_rate = 5
var ship: Player = null

func _ready() -> void:
	for chem in Chem.values():
		collectibles_on_ship[chem] = 0
		collectibles_on_earth[chem] = 0
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
		ship.earthDepositParticles.emitting = false
		drain_rate = 5
		gravity_center = target
	else:
		ship.earthDepositParticles.emitting = false
		attached_to_earth = false
		gravity_center = null
		drain_rate = 5
		
func set_ship(the_ship: Player) -> void:
	ship = the_ship
		
func _on_collectible(chemicals: CollectibleResource) -> void:
	if chemicals.energy > 0:
		ship.energy = min(100, ship.energy + chemicals.energy)
		return
	for i in chemicals.get_chems().keys():
		if i in collectibles_on_ship:
			collectibles_on_ship[i] += chemicals.chemicals[i]
		else:
			collectibles_on_ship[i] = chemicals.chemicals[i]

func _physics_process(_delta: float) -> void:
	if attached_to_earth:
		var velocity = ship.velocity
		ship.velocity = velocity.limit_length(velocity.length() * 0.99)
		
func goal_reached() -> int:
	if stage >= goals.size():
		return stage
	for i in goals[stage].keys():
		if collectibles_on_earth.get(i, 0) < goals[stage][i]:
			return -1
	stage += 1
	return stage
			
func _process(delta: float) -> void:
	if ship and ship.energy <= 0:
		print("dead as fuck")
		pass
	if attached_to_earth:
		var dist = (gravity_center.position - ship.position).length()
		if dist < gravity_center.get_real_size() + 1000:
			var didStuff = false
			for i in collectibles_on_ship.keys():
				if collectibles_on_ship[i] > 0:
					didStuff = true
					ship.earthDepositParticles.emitting = true
					# drain at rate of 5 per second
					var drain = drain_rate * delta
					if (collectibles_on_ship[i] - drain) < 0:
						drain = collectibles_on_ship[i]
					collectibles_on_ship[i] -= drain
					collectibles_on_earth[i] = collectibles_on_earth.get(i, 0) + drain
					#print(collectibles_on_earth)
			ship.energy = min(100, drain_rate * delta + ship.energy)
			if didStuff:
				var new_stage = goal_reached()
				if new_stage > 0:
					for chem in Chem.values():
						collectibles_on_earth[chem] = 0
					gravity_center.do_earth_transform(new_stage)

			on_earth_collectibles.emit(collectibles_on_earth)
			on_ship_collectibles.emit(collectibles_on_ship)
		else:
			ship.earthDepositParticles.emitting = false
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

			on_earth_collectibles.emit(collectibles_on_earth)
			on_ship_collectibles.emit(collectibles_on_ship)
	pass
