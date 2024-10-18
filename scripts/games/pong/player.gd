extends CharacterBody2D

const SPEED: float = 600.0

func _process(delta: float) -> void:
	
	var direction: int = Input.get_axis("up", "down")
	position.y += direction * SPEED * delta
