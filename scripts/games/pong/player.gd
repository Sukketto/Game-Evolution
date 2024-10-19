extends CharacterBody2D

const SPEED: float = 600.0

var can_play: bool = true

func _process(delta: float) -> void:
	
	if can_play:
		var direction: int = Input.get_axis("up", "down")
		position.y += direction * SPEED * delta
