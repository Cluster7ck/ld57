extends Control
class_name GameUi


@export var gradient: Gradient = Gradient.new()
@export var color_by_energy_level: bool = false
@export var energy_gradient: Gradient
@export var quest_texts: Quest_Texts

@onready var o_label: Label = $UIObenRechts/Panel/HBoxContainer/O_BoxContainer/PointCount
@onready var c_label: Label = $UIObenRechts/Panel/HBoxContainer/C_BoxContainer/PointCount
@onready var h_label: Label = $UIObenRechts/Panel/HBoxContainer/H_BoxContainer/PointCount
@onready var energy_label: Label = $UIObenRechts/Panel2/HBoxContainer/PointCount
@onready var txt_quest_main: Label = $UIObenRechts/Panel3/txt_quest_main
@onready var txt_quest_sub: Label = $UIObenRechts/Panel3/txt_quest_sub

@onready var help_button: Button = $UIObenLinks/Button

func _ready() -> void:
	GameManager.on_ship_collectibles.connect(_on_ship_collectibles)
	GameManager.stage_changed.connect(_on_quest_state_changed)
	
	txt_quest_main.text = quest_texts.main_text_quest_1
	txt_quest_sub.text = quest_texts.sub_text_quest_1
	_on_ship_collectibles({
		GameManager.Chem.ChemC: 0,
		GameManager.Chem.ChemO: 0,
		GameManager.Chem.ChemH: 0,
		GameManager.Chem.ChemN: 0,
	})
	help_button.pressed.connect(_on_help_button)


func _on_ship_collectibles(collectibles: Dictionary) -> void:
	for key in collectibles.keys():
		var goals = {
			GameManager.Chem.ChemC: 10,
			GameManager.Chem.ChemO: 10,
			GameManager.Chem.ChemH: 10,
			GameManager.Chem.ChemN: 10,
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

func _on_quest_state_changed(_stage: int):
	match _stage:
		0: 
			txt_quest_main.text = quest_texts.main_text_quest_1
			txt_quest_sub.text = quest_texts.sub_text_quest_1
			pass
		1: 
			txt_quest_main.text = quest_texts.main_text_quest_2
			txt_quest_sub.text = quest_texts.sub_text_quest_2
			pass
		2: 
			txt_quest_main.text = quest_texts.main_text_quest_3
			txt_quest_sub.text = quest_texts.sub_text_quest_3
			pass
		pass
	pass

func fmt(current, goal):
	return str(int(ceil(current))) + "/" + str(int(floor(goal)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if color_by_energy_level:
		energy_label.label_settings.font_color = energy_gradient.sample(GameManager.ship.energy/100)
	energy_label.text = str(int(floor(GameManager.ship.energy))) + "%"
	if GameManager.is_goal_reached_ship():
		txt_quest_sub.text = " - Return to Earth - "
		pass

func _on_help_button():
	GameManager.ui_manager.open_intro()
	pass
