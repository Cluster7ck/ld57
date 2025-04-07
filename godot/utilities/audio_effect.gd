extends Node2D

@export var audio_clip: AudioStreamWAV
@export var pitch_range: float = 0
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_2d.pitch_scale = 1 + rng.randf_range(-pitch_range, pitch_range)
	audio_stream_player_2d.stream = audio_clip
	audio_stream_player_2d.finished.connect(_on_finished)

func _on_finished():
	queue_free()
