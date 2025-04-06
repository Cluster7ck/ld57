extends CharacterBody2D

@onready var line: Line2D = $Line2D
@onready var hololine: Line2D = $HoloLine2D
@onready var earthTether: Line2D = $EarthTether
@onready var sprite: Node2D = $Node2D
@export var initialBoost = 600

@export var DEFAULT_GRAVITY = 600.0
@export var PLANET_GRAVITY = 800.0
@export var dampingFactor = 20
@export var orbitPullSpeed = 100
var gravity_c = 600.0
var gravityDirection = Vector2(0, 1)
var gravityCenter: GravityCenter = null

func _ready() -> void:
	GameManager.gravity_target.connect(on_new_gravity_center)
	velocity = Vector2(100, 0)
	GameManager.set_ship(self)
	pass

func on_new_gravity_center(gravity_center: GravityCenter):
	if gravity_center:
		gravityCenter = gravity_center
		velocity += (gravityCenter.position - position).normalized() * initialBoost
		#var tween = get_tree().create_tween()
		#tween.tween_property(self, gravity_c, PLANET_GRAVITY, 0.2)
		#tween.tween_callback(self.queue_free)
	else:
		gravityCenter = null
		line.clear_points()
		earthTether.clear_points()
		hololine.clear_points()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			GameManager.gravity_target.emit(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if gravityCenter:
		var dirToPlanet = gravityCenter.position - position
		#if gravityCenter.name == "Erde":
		#	var orbit = gravityCenter.get_real_size() + 300
		#	var targetSpeed = sqrt(gravity_c * 2 * orbit)
		#	var perp = Vector2(dirToPlanet.y, dirToPlanet.x).normalized()
		#	# adjust velocity to be more perpendicular to the planet
		#	velocity += perp * delta * orbitPullSpeed
		#	velocity = velocity.limit_length(targetSpeed)
		#	gravityDirection = (dirToPlanet).normalized()
		#	velocity += gravityDirection * delta * gravity_c * 2;
		#	var motion = velocity * delta
		#	move_and_collide(motion)
		#	
		#else:
		#print(dirToPlanet.length())
		gravityDirection = (dirToPlanet).normalized()
		print(gravityDirection)
		velocity += gravityDirection * delta * gravity_c * 2;
		print(velocity)
		
		var motion = velocity * delta
		move_and_collide(motion)
	else:
		velocity = velocity.limit_length(velocity.length() * 0.999)
		var motion = velocity * delta
		move_and_collide(motion)

func _process(_delta) -> void:
	sprite.look_at(position + velocity)
	if gravityCenter:
		line.clear_points()
		line.add_point(gravityCenter.position - position)
		line.add_point(Vector2(0, 0))
		hololine.clear_points()
		hololine.add_point(gravityCenter.position - position)
		hololine.add_point(Vector2(0, 0))
		if gravityCenter.name == "Erde":
			earthTether.clear_points()
			earthTether.add_point(gravityCenter.position - position)
			earthTether.add_point(Vector2(0, 0))
	
