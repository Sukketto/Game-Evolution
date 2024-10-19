extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().is_on_ladder = true

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().is_on_ladder = false
