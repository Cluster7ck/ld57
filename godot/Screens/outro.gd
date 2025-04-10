extends Control

@onready var button: Button = $Panel/Button
@onready var txt_timecont: Label = $Panel/txt_timecont
@onready var txt_energy: Label = $Panel/timecont3
@onready var txt_planets: Label = $Panel/timecont2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	visibility_changed.connect(_on_visibility_changed)
	pass # Replace with function body.

func _on_button_pressed():
	GameManager.restart_game()

func set_values():
	var m: int = 0
	var minutes_string: String = ""
	m = floor(GameManager.time_in_game /60)
	if m < 10:
		minutes_string = "0"
	minutes_string += str(m)
	
	var s: int = 0
	var seconds_string: String = ""
	s = fmod(floor(GameManager.time_in_game), 60)
	if s < 10:
		seconds_string = "0"
	seconds_string += str(s)
	
	txt_timecont.text = minutes_string + ":" + seconds_string
	txt_energy.text = str(int(GameManager.total_energy_drained))
	txt_planets.text = str(int(GameManager.total_planets_visited))
	
	pass

func _on_visibility_changed():
	if is_visible_in_tree():
		set_values()
	pass
