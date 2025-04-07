extends Area2D
class_name GravityCenter

const DEFAULT_SIZE = 222
@export var collectibles: CollectibleResource
@export var drainFrom: bool = true
@onready var spriteParent: Node2D = $Kreis
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var circleSprite: CanvasItem = $Kreis
@onready var blur: CanvasItem = $Blur

var stage = 0
var lastFrameEmit = -1
var rng = RandomNumberGenerator.new()


func _ready() -> void:
	if name != "Erde":
		rotation = rng.randf_range(0, TAU)
		var randScale = rng.randfn(1.5, 0.5)
		apply_scale(Vector2(randScale, randScale))
		#spriteParent.apply_scale(Vector2(randScale, randScale))
		#print(collisionShape.shape.radius)
		#collisionShape.shape.set_radius((collisionShape.shape.radius * randScale) + 200)
	else:
		apply_scale(Vector2(2.5, 2.5))
		
func do_earth_transform(new_stage: int):
	if stage == new_stage - 1 and new_stage == 1:
		stage += 1
		var tween = create_tween()
		tween.tween_property(blur, "modulate", Color.hex(0x4395a1ff), 1)
		tween.tween_property(circleSprite, "modulate", Color.hex(0x0084c2ff), 1)
	if stage == new_stage - 1 and new_stage == 2:
		stage += 1
		var tween = create_tween()
		tween.tween_property(get_node(^"AnimatedSprite2D"), "modulate", Color.hex(0x6de3d1ff), 1)
	if stage == new_stage - 1 and new_stage == 3:
		stage += 1
		var tween = create_tween()
		tween.tween_property(get_node(^"Atmosphere"), "modulate", Color(79/255, 188/255, 255/255, 100/255), 1)
		

func get_real_size() -> float:
	return DEFAULT_SIZE * scale.x

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if GameManager.current_state != GameManagerClass.GameState.playing:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and lastFrameEmit != Engine.get_frames_drawn():
			#print("emitting gravity target " + str(Engine.get_frames_drawn()) + ", " + str(get_instance_id()))
			GameManager.gravity_target.emit(self)
			lastFrameEmit = Engine.get_frames_drawn()
