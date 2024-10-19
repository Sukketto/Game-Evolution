extends Node2D

var barrel_scene: PackedScene = preload("res://scenes/games/donkey_kong/barrel.tscn")

func _on_spawn_timer_timeout() -> void:
	var barrel: CharacterBody2D = barrel_scene.instantiate()
	barrel.global_position = global_position
	get_parent().add_child(barrel)
