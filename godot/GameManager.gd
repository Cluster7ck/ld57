extends Node

signal gravity_target(position)
signal on_collectible()

var collectibles = 0

func _ready() -> void:
	on_collectible.connect(_on_collectible)

func _on_collectible():
	collectibles += 1
	print("collectible %s" % collectibles)
