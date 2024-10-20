extends Node2D
var game_finished: bool = false

func _on_next_level_area_body_entered(body: Node2D) -> void:
	if body is PlayerDK:
		$Livello.avanza(100)
		$AudioStreamPlayer.play()
		body.queue_free()
		$NextLevelArea/AnimatedSprite2D.play("change_level")
		await $AudioStreamPlayer.finished
		$Livello.prossimo()

func _on_livello_avanzamento_finito() -> void:
	game_finished = true
	$UI/WinLabel.visible = true
