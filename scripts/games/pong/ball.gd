extends CharacterBody2D

const SPEED: float = 25.0

func _ready() -> void:
	velocity = Vector2(-SPEED, 0)

func _process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity)
	if collision:
		var normal := collision.get_normal()
		velocity = velocity.bounce(normal)
