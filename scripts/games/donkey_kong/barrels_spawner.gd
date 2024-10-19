extends Node2D

var barrel_scene: PackedScene = preload("res://scenes/games/donkey_kong/barrel.tscn")
var barrels_counter: int = 0

func _on_spawn_timer_timeout() -> void:
	check_barrels()
	if barrels_counter < 10:
		var barrel: CharacterBody2D = barrel_scene.instantiate()
		barrel.global_position = global_position
		get_parent().add_child(barrel)

func check_barrels():
	barrels_counter = 0
	for b in $"..".get_children():
		if b is Barrel:
			barrels_counter += 1
			print(barrels_counter )
