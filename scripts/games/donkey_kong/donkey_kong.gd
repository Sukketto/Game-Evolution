extends Node2D

func _on_next_level_area_body_entered(body: Node2D) -> void:
	if body is PlayerDK:
		body.queue_free()
		$NextLevelArea/AnimatedSprite2D.play("change_level")
