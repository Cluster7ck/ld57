extends Control
class_name GameUi

@onready var o_label: Label = $UIObenRechts/Panel/HBoxContainer/O_BoxContainer/PointCount
@onready var c_label: Label = $UIObenRechts/Panel/HBoxContainer/C_BoxContainer/PointCount
@onready var h_label: Label = $UIObenRechts/Panel/HBoxContainer/H_BoxContainer/PointCount

func _ready() -> void:
	GameManager.on_ship_collectibles.connect(_on_ship_collectibles)
	pass # Replace with function body.

func _on_ship_collectibles(collectibles: Dictionary) -> void:
	for key in collectibles.keys():
		if key == GameManager.Chem.ChemH:
			h_label.text = fmt(collectibles[key], max(0, GameManager.goals[GameManager.stage][key]-GameManager.collectibles_on_earth[key]))
		elif key == GameManager.Chem.ChemO:
			o_label.text = fmt(collectibles[key], max(0, GameManager.goals[GameManager.stage][key]-GameManager.collectibles_on_earth[key]))
		elif key == GameManager.Chem.ChemC:
			c_label.text = fmt(collectibles[key], max(0, GameManager.goals[GameManager.stage][key]-GameManager.collectibles_on_earth[key]))
		elif key == GameManager.Chem.ChemN:
			pass
			# Handle Nitrogen if needed
			
func fmt(current, goal):
	return str(int(floor(current))) + "/" + str(int(floor(goal)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
