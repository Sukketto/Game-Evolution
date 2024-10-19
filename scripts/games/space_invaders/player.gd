class_name Player extends CharacterBody2D

const SPEED: float = 600.0

var bullet_scene: PackedScene = preload("res://scenes/games/space_invaders/bullet.tscn")

func _process(delta: float) -> void:
	
	var direction: int = Input.get_axis("left", "right")
	position.x += direction * SPEED * delta
	
	if Input.is_action_just_pressed("primary_action"):
		spawn_bullet()

func spawn_bullet():
	var bullet: Area2D = bullet_scene.instantiate()
	bullet.global_position = global_position - Vector2(0, 50)
	get_parent().add_child(bullet)
