extends Resource
class_name CollectibleResource

@export var h_amount: int
@export var o_amount: int
@export var c_amount: int
@export var n_amount: int

var chemicals = {}
func get_chems() -> Dictionary:
	chemicals[GameManager.Chem.ChemH] = h_amount
	chemicals[GameManager.Chem.ChemO] = o_amount
	chemicals[GameManager.Chem.ChemC] = c_amount
	chemicals[GameManager.Chem.ChemN] = n_amount
	return chemicals
