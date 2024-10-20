extends Node2D

var game_finished: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("primary_action") and game_finished:
		$Transition.play()

func _on_livello_avanzamento_finito() -> void:
	game_finished = true
	$UI/WinLabel.visible = true
	$Player.can_play = false
	$Player.reset()
	for c in get_children():
		if c is Shield or c is EnemySI:
			c.queue_free()

func _on_transition_finished() -> void:
	$Livello.prossimo()
