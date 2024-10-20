extends Node2D

var game_finished: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("primary_action") and game_finished:
		$Transition.play()

func _on_player_area_body_entered(body: Node2D) -> void:
	if body is Ball:
		body.restart()

func _on_enemy_area_body_entered(body: Node2D) -> void:
	if body is Ball:
		body.restart()
		$Livello.avanza(25)

func _on_livello_avanzamento_finito() -> void:
	game_finished = true
	$UI/WinLabel.visible = true
	$Ball.reset()
	$Player.can_play = false

func _on_transition_finished() -> void:
	$Livello.prossimo()
