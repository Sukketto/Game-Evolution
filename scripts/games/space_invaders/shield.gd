class_name Shield extends StaticBody2D

var state: int = 3

func _process(delta: float) -> void:
	match state:
		3:
			$Sprite2D.texture = load("res://assets/games/space_invaders/shield_new_si.png")
		2:
			$Sprite2D.texture = load("res://assets/games/space_invaders/shield_lessbroken_si.asesprite.png")
		1:
			$Sprite2D.texture = load("res://assets/games/space_invaders/shield_lessbroken_si.asesprite.png")
	
	if state <= 0:
		queue_free()
