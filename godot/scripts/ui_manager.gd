class_name UIManager
extends Node2D

@export var intro_screen: Control
@export var outro_screen: Control
@export var gameOver_screen: Control

@export var earth_indicator: Node2D
@export var path2d: Path2D
@export var path2dFollower: PathFollow2D
@export var compass_distance_to_ship: int = 200
@export var warp_fade_animation_player: AnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var earth: Node2D
var ship: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intro_screen.visible = true
	outro_screen.visible = false
	gameOver_screen.visible = false
	GameManager.on_new_earth.connect(_on_new_earth)
	GameManager.on_new_ship.connect(_on_new_ship)
	pass # Replace with function body.
	
func _on_new_earth(new_earth: Node2D):
	earth = new_earth
	var notifier : VisibleOnScreenNotifier2D = earth.find_child("VisibleOnScreenNotifier2D")
	if !notifier.screen_exited.is_connected(_on_earth_leaves_viewport):
		notifier.screen_exited.connect(_on_earth_leaves_viewport)
		notifier.screen_entered.connect(_on_earth_enters_viewport)
		
func _on_new_ship(new_ship: Node2D):
	ship = new_ship


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GameManager.current_state == GameManagerClass.GameState.playing:
		if earth_indicator.visible:
			if path2d.curve.point_count < 2:
				path2d.curve.add_point(ship.position)
				path2d.curve.add_point(earth.position)
			if !earth or !ship:
				return
			path2d.curve.set_point_position(0, ship.position)
			path2d.curve.set_point_position(1, earth.position)
			if GameManager.is_goal_reached_ship() && !animation_player.is_playing():
				animation_player.play("arrow_pulsating")
			elif !GameManager.is_goal_reached_ship():
				animation_player.stop()
			path2dFollower.progress = compass_distance_to_ship


func open_intro():
	GameManager.current_state = GameManagerClass.GameState.pause
	intro_screen.visible = true
	pass

func finish_intro():
	intro_screen.visible = false
	pass

func gameOver():
	## fancy game over sequence here
	gameOver_screen.visible = true
	pass

func win():
	## fancy win sequence here
	outro_screen.visible = true
	pass

func _on_earth_leaves_viewport():
	earth_indicator.visible = true
	pass

func _on_earth_enters_viewport():
	earth_indicator.visible = false
	pass

func distance_to_screen_border():
	var rect = get_viewport_rect().size / 2.0
	
	pass

func warp_fade_in():
	warp_fade_animation_player.play("fade_in")
	pass

func warp_fade_out():
	warp_fade_animation_player.play("fade_out")
	pass
