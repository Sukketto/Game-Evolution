extends Node2D

func _on_next_level_area_body_entered(body: Node2D) -> void:
	if body is PlayerDK:
		body.queue_free()
		$NextLevelArea/AnimatedSprite2D.play("change_level")
		await $NextLevelArea/AnimatedSprite2D.animation_finished
		$Livello.avanza(100)

func _on_livello_avanzamento_finito() -> void:
	$Livello.prossimo()
