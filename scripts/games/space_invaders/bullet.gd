extends Area2D

var direction: Vector2
const SPEED: float = 1000.0

func _ready() -> void:
	direction = Vector2.DOWN if modulate == Color("00ff16") else Vector2.UP

func _process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Shield:
		body.state -= 1
		queue_free()
	else:
		body.queue_free()
		queue_free()
