extends Control

@export var btn1: Button
@export var btn2: Button
@export var btn3: Button
@export var btn4: Button

@export var panel_parent: Control
@onready var ui_manager: UIManager = %UIManager

var panels: Array = []
var current_panel: int = 0:
	set(value):
		current_panel = value
		update_visible_panel()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn1.pressed.connect(next_intro_screen)
	btn2.pressed.connect(next_intro_screen)
	btn3.pressed.connect(next_intro_screen)
	btn4.pressed.connect(_on_btn4_up)
	panels = panel_parent.get_children()
	
	update_visible_panel()



func update_visible_panel():
	for panel:Control in panels:
		panel.visible = false
	panels[current_panel].visible = true


func next_intro_screen():
	current_panel += 1


func _on_btn4_up():
	ui_manager.finish_intro()
	GameManager.current_state = GameManagerClass.GameState.playing
