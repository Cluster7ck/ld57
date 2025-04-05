extends Camera2D

@export var target: Node = null
@export var speed = 600
@export var focusPlanet = false

var hasGravityCenter = false
var gravityCenterPos: Vector2 = Vector2(0, 0)

func _ready() -> void:
	GravityEventManager.gravity_target.connect(on_new_gravity_center)
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
			position = target.position
	else:
		if hasGravityCenter:
			var dir = gravityCenterPos - target.position
			dir = dir.limit_length(dir.length() * 0.5)
			position = target.position + dir
		else:
			position = target.position
	
