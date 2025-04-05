extends CharacterBody2D

@onready var line: Line2D = $Line2D
@onready var sprite: Node2D = $Node2D
@export var initialBoost = 600

@export var DEFAULT_GRAVITY = 600.0
@export var PLANET_GRAVITY = 800.0
@export var dampingFactor = 20
var gravity_c = 600.0
var gravityDirection = Vector2(0, 1)
var hasGravityCenter = false
var gravityCenterPos = Vector2(0, 0)

func _ready() -> void:
	GravityEventManager.gravity_target.connect(on_new_gravity_center)
	pass

func on_new_gravity_center(gravity_center_pos):
	if gravity_center_pos:
		gravityCenterPos = gravity_center_pos
		hasGravityCenter = true
		velocity += (gravityCenterPos - position).normalized() * initialBoost
		#var tween = get_tree().create_tween()
		#tween.tween_property(self, gravity_c, PLANET_GRAVITY, 0.2)
		#tween.tween_callback(self.queue_free)
	else:
		hasGravityCenter = false
		line.clear_points()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			GravityEventManager.gravity_target.emit(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !hasGravityCenter:
		velocity = velocity.limit_length(velocity.length() * 0.999)
		var motion = velocity * delta
		move_and_collide(motion)
	else:
		var dirToPlanet = gravityCenterPos - position
		gravityDirection = (dirToPlanet).normalized()
		velocity += gravityDirection * delta * gravity_c * 2;
		var motion = velocity * delta
		move_and_collide(motion)

func _process(_delta) -> void:
	sprite.look_at(position + velocity)
	if hasGravityCenter:
		line.clear_points()
		line.add_point(gravityCenterPos - position)
		line.add_point(Vector2(0, 0))
