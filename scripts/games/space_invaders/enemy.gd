class_name EnemySI extends CharacterBody2D

var direction: int = 1
const SPEED: float = 100.0

var bullet_scene: PackedScene = preload("res://scenes/games/space_invaders/bullet.tscn")

func _process(delta: float) -> void:
	position.y += direction * SPEED * delta

func _on_change_dir_timer_timeout() -> void:
	direction = -1 if direction == 1 else 1

func _on_shoot_timer_timeout() -> void:
	var bullet: Area2D = bullet_scene.instantiate()
	bullet.modulate = Color("AA1111")
	bullet.global_position = global_position - Vector2(50, 0)
	$"../..".add_child(bullet)
