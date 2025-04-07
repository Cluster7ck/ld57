extends Node2D

@export var audio_clip: AudioStreamWAV
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_2d.stream = audio_clip
	audio_stream_player_2d.finished.connect(_on_finished)

func _on_finished():
	queue_free()
