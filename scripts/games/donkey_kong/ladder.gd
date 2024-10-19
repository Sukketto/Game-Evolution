extends Area2D

func _ready() -> void:
	randomize()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().is_on_ladder = true
	elif area.is_in_group("barrel"):
		if (randi() % 100) < 50:
			area.get_parent().go_down = true

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().is_on_ladder = false
	elif area.is_in_group("barrel"):
		area.get_parent().go_down = false
