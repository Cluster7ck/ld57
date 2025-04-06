extends Camera2D

@export var target: CharacterBody2D = null
@export var speed = 600
@export var focusPlanet = false
@export var lookAheadMul = 10

var hasGravityCenter = false
var gravityCenterPos: Vector2 = Vector2(0, 0)

var default_zoom
var max_vel = 1
var zoom_scale

func _ready() -> void:
	GameManager.gravity_target.connect(on_new_gravity_center)
	default_zoom = zoom
	pass
	
func on_new_gravity_center(gravity_center_pos):
	if gravity_center_pos:
		if focusPlanet:
			position = gravity_center_pos
		gravityCenterPos = gravity_center_pos
		hasGravityCenter = true
	else:
		hasGravityCenter = false

func _process(delta):
	if focusPlanet:
		if !hasGravityCenter and target:
			position = target.position + target.velocity.normalized() * lookAheadMul
	else:
		if hasGravityCenter:
			var dir = gravityCenterPos - target.position
			dir = dir.limit_length(dir.length() * 0.5)
			position = target.position + dir
		else:
			position = target.position + target.velocity.normalized() * lookAheadMul
	
	#zoom_by_speed()


func zoom_by_speed():
	max_vel = max(max_vel, target.velocity.length())
	var scale = max(abs(1-target.velocity.length()/max_vel), 0.2)
	print("scale: ", scale)
	zoom = default_zoom - Vector2(scale, scale)
	pass
