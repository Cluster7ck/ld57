extends Area2D
class_name Collectible

@export var collectible_resource: CollectibleResource
const AUDIO_EFFECT = preload("res://utilities/audio_effect.tscn")
@export var on_pickup_clip: AudioStreamWAV

func _ready() -> void:
	body_entered.connect(on_player_enter)


func on_player_enter(_body: Node2D):
	if collectible_resource:
		GameManager.on_collectible.emit(self)
		# todo - add animation
	else:
		pass

func do_collection():
	var effect = AUDIO_EFFECT.instantiate()
	effect.audio_clip = on_pickup_clip
	get_tree().root.add_child(effect)
	effect.audio_stream_player_2d.play()
	queue_free()
