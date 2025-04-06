extends Area2D

@export var collectible_resource: CollectibleResource

func _ready() -> void:
	body_entered.connect(on_player_enter)

func on_player_enter(_body: Node2D):
	GameManager.on_collectible.emit(collectible_resource)
	# todo - add animation
	queue_free()
