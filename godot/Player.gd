extends CharacterBody2D
class_name Player

@onready var line: Line2D = $Line2D
@onready var hololine: Line2D = $HoloLine2D
@onready var earthTether: Line2D = $EarthTether
@onready var earthDepositParticles: CPUParticles2D = $EarthDepositParticles2D
@onready var sprite: Node2D = $Node2D
@export var initialBoost = 100
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var warp_fade_animation_player: AnimationPlayer = $"../CanvasLayer/Warp Fade/AnimationPlayer"

@export var DEFAULT_GRAVITY = 600.0
@export var PLANET_GRAVITY = 800.0
@export var dampingFactor = 20
@export var orbitPullSpeed = 100
@export var tractor_beam_range = 1000
@export var tractor_beam_snap_range = 3500
@export var energy_drain_rate = 1
@export var tractor_beam_energy_gradient: Gradient
@export var space_boundaries: Vector2 = Vector2(30000, 30000)

var gravity_c = 600.0
var gravityDirection = Vector2(0, 1)
var gravityCenter: GravityCenter = null
var hololine_default_alpha
var current_tractor_beam_length = 0
var energy = 100.0

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	hololine_default_alpha = hololine.modulate.a
	velocity = Vector2(100, 0)
	warp_fade_animation_player.animation_finished.connect(_on_fade_finished)
	GameManager.gravity_target.connect(on_new_gravity_center)
	GameManager.on_new_ship.emit(self)


func on_new_gravity_center(gravity_center: GravityCenter):
	if gravity_center:
		gravityCenter = gravity_center
		velocity += (gravityCenter.position - position).normalized() * initialBoost
		audio_stream_player_2d.pitch_scale = rng.randf_range(0.97, 1.03)
		audio_stream_player_2d.play(0.00)
		
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
	if GameManager.current_state != GameManagerClass.GameState.playing:
		return
	if gravityCenter:
		var dirToPlanet = gravityCenter.position - position
		gravityDirection = (dirToPlanet).normalized()
		velocity += gravityDirection * delta * gravity_c * 2;
		
		var motion = velocity * delta
		move_and_collide(motion)
	else:
		velocity = velocity.limit_length(velocity.length() * 0.999)
		var motion = velocity * delta
		move_and_collide(motion)

func _process(delta) -> void:
	
	if GameManager.current_state != GameManagerClass.GameState.playing:
		return
	sprite.look_at(position + velocity)
	if gravityCenter:
		if gravityCenter.name != "Erde":
			energy = max(0, energy - energy_drain_rate * delta)
		if hololine.get_point_count() > 1:
			current_tractor_beam_length = hololine.get_point_position(0).distance_to(hololine.get_point_position(1))
		else:
			current_tractor_beam_length = 0
		line.clear_points()
		line.add_point(gravityCenter.position - position)
		line.add_point(Vector2(0, 0))
		hololine.clear_points()
		hololine.add_point(gravityCenter.position - position)
		hololine.add_point(Vector2(0, 0))
		
		var beam_alpha = 1-current_tractor_beam_length/tractor_beam_snap_range
		var color = tractor_beam_energy_gradient.sample(energy/100)
		hololine.modulate = color
		hololine.modulate.a = hololine_default_alpha * beam_alpha
		line.material.set_shader_parameter("alpha", beam_alpha*2)
		line.material.set_shader_parameter("override_color", Vector3(color.r, color.g, color.b))
		if gravityCenter.name == "Erde":
			earthTether.clear_points()
			earthTether.add_point(gravityCenter.position - position)
			earthTether.add_point(Vector2(0, 0))
		#if current_tractor_beam_length > tractor_beam_snap_range:
		#	GameManager.gravity_target.emit(null)
		
	## X-Loop
	if position.x <= -space_boundaries.x && velocity.x < 0 || position.x >= space_boundaries.x && velocity.x > 0:
		GameManager.ui_manager.warp_fade_in()
		## Snap on warping
		GameManager.gravity_target.emit(null)
		#position.x = position.x *-1
		#if velocity.length() < 800:
			#velocity *= 1000
			#velocity.limit_length(800)
	## Y-Loop
	if position.y <= -space_boundaries.y && velocity.y < 0 || position.y >= space_boundaries.y && velocity.y > 0:
		GameManager.ui_manager.warp_fade_in()
		## Snap on warping
		GameManager.gravity_target.emit(null)
		#position.y = position.y *-1
		#if velocity.length() < 800:
			#velocity *= 1000
			#velocity.limit_length(800)
		


	
func _on_fade_finished(anim_name: StringName):
	if anim_name == "fade_in":
		if position.x <= -space_boundaries.x && velocity.x < 0 || position.x >= space_boundaries.x && velocity.x > 0:
			position.x = position.x *-1
			
		if position.y <= -space_boundaries.y && velocity.y < 0 || position.y >= space_boundaries.y && velocity.y > 0:
			position.y = position.y *-1
		
		if velocity.length() < 800:
			velocity *= 1000
			velocity.limit_length(800)
		
		GameManager.ui_manager.warp_fade_out()
	if anim_name == "fade_out":
		pass
	pass
