extends Node2D


func _on_player_area_body_entered(body: Node2D) -> void:
	pass

func _on_enemy_area_body_entered(body: Node2D) -> void:
	if body is Ball:
		$Livello.avanza(25)
