extends Control

@onready var button: Button = $Panel/Button
@export var txt_collected_resources: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	visibility_changed.connect(_on_visibility_changed)
	
func set_values():
	txt_collected_resources.text = str(GameManager.total_collectible_count)
	pass



func _on_button_pressed():
	GameManager.restart_game()
	pass

func _on_visibility_changed():
	if is_visible_in_tree():
		set_values()
	pass
