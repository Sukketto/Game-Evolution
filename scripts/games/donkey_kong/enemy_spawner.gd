extends Area2D

var enemy_scene: PackedScene = preload("res://scenes/games/donkey_kong/enemy.tscn")

var counter: int = 0

func _on_body_entered(body: Node2D) -> void:
	if body is Barrel:
		counter += 1
		if counter % 4 == 0 and counter != 0:
			if not is_enemy():
				var enemy = enemy_scene.instantiate()
				enemy.position = position
				# Usa call_deferred per aggiungere il nemico dopo che il motore ha finito di processare la fisica
				get_parent().call_deferred("add_child", enemy)
		body.queue_free()

func is_enemy() -> bool:
	for enemy in $"..".get_children():
		if enemy is EnemyDK:
			return true
	return false
