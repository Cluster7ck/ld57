extends Camera2D

@export var target: Node = null
@export var speed = 600


func _process(delta):
	if target:
		position = target.position
	else:
		print("ney")
	
