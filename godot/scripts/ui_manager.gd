class_name UIManager
extends Node2D

@export var intro_screen: Control
@export var outro_screen: Control
@export var gameOver_screen: Control

@export var earth_indicator: Node2D
@export var path2d: Path2D
@export var path2dFollower: PathFollow2D
@export var compass_distance_to_ship: int = 200

var earth: 
	set(value):
		earth = value
		var notifier : VisibleOnScreenNotifier2D = earth.find_child("VisibleOnScreenNotifier2D")
		if !notifier.screen_exited.is_connected(_on_earth_leaves_viewport):
			notifier.screen_exited.connect(_on_earth_leaves_viewport)
			notifier.screen_entered.connect(_on_earth_enters_viewport)
var ship: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intro_screen.visible = true
	outro_screen.visible = false
	gameOver_screen.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if earth_indicator.visible:
		if path2d.curve.point_count < 2:
			path2d.curve.add_point(ship.position)
			path2d.curve.add_point(earth.position)
		path2d.curve.set_point_position(0, ship.position)
		path2d.curve.set_point_position(1, earth.position)
		
		path2dFollower.progress = compass_distance_to_ship


func finish_intro():
	intro_screen.visible = false
	pass

func _on_earth_leaves_viewport():
	earth_indicator.visible = true
	#print("leave")
	pass

func _on_earth_enters_viewport():
	#print("enters")
	earth_indicator.visible = false
	pass

func distance_to_screen_border():
	var rect = get_viewport_rect().size / 2.0
	
	pass

func calculateIntersection(target_position: Vector2) -> Vector2:
	var player_position = ship.position
	var direction = player_position - target_position
	var rect = get_viewport_rect().size / 2.0
	var camera_position = player_position - rect
	var top_left = (player_position - rect - target_position).angle()
	var top_right = (player_position + Vector2(rect.x, -rect.y) - target_position).angle()
	var bottom_left = (player_position + Vector2(-rect.x, rect.y) - target_position).angle()
	var bottom_right = (player_position + rect - target_position).angle()
	var direction_n = (target_position - player_position).normalized()
	var intersection: Vector2
	
	if (direction.angle() > top_left and direction.angle() < top_right) \
		or (direction.angle() < bottom_left and direction.angle() > bottom_right):
		#Target is behind top/bottom edge
		if direction_n.y < 0:
			var x_intersection = player_position.x + (camera_position.y - player_position.y) / direction_n.y * direction_n.x
			intersection = Vector2(x_intersection, camera_position.y + 5)
		elif direction_n.y > 0:
			var x_intersection = player_position.x - (camera_position.y - player_position.y) / direction_n.y * direction_n.x
			intersection = Vector2(x_intersection, player_position.y + rect.y - 5)
	else:
		if direction_n.x < 0:
			var y_intersection = player_position.y + (camera_position.x - player_position.x) / direction_n.x * direction_n.y
			intersection = Vector2(camera_position.x + 5, y_intersection)
		elif direction_n.x > 0:
			var y_intersection = player_position.y - (camera_position.x - player_position.x) / direction_n.x * direction_n.y
			intersection = Vector2(player_position.x + rect.x - 5, y_intersection)
	
	intersection.x = clamp(intersection.x, camera_position.x + 5, player_position.x + rect.x - 5)
	intersection.y = clamp(intersection.y, camera_position.y + 5, player_position.y + rect.y - 5)
	
	return intersection
