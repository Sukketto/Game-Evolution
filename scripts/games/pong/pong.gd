extends Node2D

func _on_player_area_body_entered(body: Node2D) -> void:
	if body is Ball:
		body.restart()

func _on_enemy_area_body_entered(body: Node2D) -> void:
	if body is Ball:
		body.restart()
		$Livello.avanza(25)

func _on_livello_avanzamento_finito() -> void:
	$UI/WinLabel.visible = true
	$Ball.reset()
	$Player.can_play = false
	$Livello.prossimo()
