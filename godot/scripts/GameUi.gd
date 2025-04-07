extends Control
class_name GameUi

@export var gradient: Gradient = Gradient.new()
@onready var o_label: Label = $UIObenRechts/Panel/HBoxContainer/O_BoxContainer/PointCount
@onready var c_label: Label = $UIObenRechts/Panel/HBoxContainer/C_BoxContainer/PointCount
@onready var h_label: Label = $UIObenRechts/Panel/HBoxContainer/H_BoxContainer/PointCount
@onready var energy_label: Label = $UIObenRechts/Panel2/HBoxContainer/PointCount

func _ready() -> void:
	GameManager.on_ship_collectibles.connect(_on_ship_collectibles)
	_on_ship_collectibles(GameManager.collectibles_on_ship)
	pass # Replace with function body.

func _on_ship_collectibles(collectibles: Dictionary) -> void:
	for key in collectibles.keys():
		var goals = {
			GameManager.Chem.ChemC: 10000,
			GameManager.Chem.ChemO: 10000,
			GameManager.Chem.ChemH: 10000,
			GameManager.Chem.ChemN: 10000,
		}
		if GameManager.stage <= 2:
			goals = GameManager.goals[GameManager.stage]
		
		if key == GameManager.Chem.ChemH:
			h_label.text = fmt(collectibles[key], max(0, goals[key]))
		elif key == GameManager.Chem.ChemO:
			o_label.text = fmt(collectibles[key], max(0, goals[key]))
		elif key == GameManager.Chem.ChemC:
			c_label.text = fmt(collectibles[key], max(0, goals[key]))
		elif key == GameManager.Chem.ChemN:
			pass
			# Handle Nitrogen if needed
			
func fmt(current, goal):
	return str(int(floor(current))) + "/" + str(int(floor(goal)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	energy_label.text = str(int(floor(GameManager.ship.energy))) + "%"
