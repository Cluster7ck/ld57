extends Area2D

func _ready() -> void:
	body_entered.connect(on_player_enter)

func on_player_enter(_body: Node2D):
	GameManager.on_collectible.emit()
	# todo - add animation
	queue_free()
