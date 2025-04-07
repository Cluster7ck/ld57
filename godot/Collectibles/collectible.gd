extends Area2D

@export var collectible_resource: CollectibleResource
const AUDIO_EFFECT = preload("res://utilities/audio_effect.tscn")
@export var on_pickup_clip: AudioStreamWAV

func _ready() -> void:
	body_entered.connect(on_player_enter)


func on_player_enter(_body: Node2D):
	if collectible_resource:
		GameManager.on_collectible.emit(collectible_resource)
		var effect = AUDIO_EFFECT.instantiate()
		effect.audio_clip = on_pickup_clip
		get_tree().root.add_child(effect)
		effect.audio_stream_player_2d.play()
		# todo - add animation
		queue_free()
	else:
		pass
