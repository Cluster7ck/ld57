extends CharacterBody2D

@export var initialBoost = 600

@export var DEFAULT_GRAVITY = 600.0
@export var PLANET_GRAVITY = 800.0
@export var dampingFactor = 20
var gravity_c = 600.0
var gravityDirection = Vector2(0, 1)
var hasGravityCenter = false
var gravityCenterPos = Vector2(0, 0)

func _ready() -> void:
	print(dampingFactor)
	GravityEventManager.gravity_target.connect(on_new_gravity_center)
	pass

func on_new_gravity_center(gravity_center_pos):
	gravityCenterPos = gravity_center_pos
	hasGravityCenter = true
	velocity += (gravityCenterPos - position).normalized() * initialBoost
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, gravity_c, PLANET_GRAVITY, 0.2)
	#tween.tween_callback(self.queue_free)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			hasGravityCenter = false
			#var tween = get_tree().create_tween()
			#tween.tween_property(self, gravity_c, DEFAULT_GRAVITY, 0.2)

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
