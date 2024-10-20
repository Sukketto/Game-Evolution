class_name PlayerSI extends CharacterBody2D

const SPEED: float = 600.0

var bullet_scene: PackedScene = preload("res://scenes/games/space_invaders/bullet.tscn")
var can_play: bool = true

func _process(delta: float) -> void:
	
	if can_play:
		var direction: int = Input.get_axis("up", "down")
		position.y += direction * SPEED * delta
		
		if Input.is_action_just_pressed("primary_action"):
			spawn_bullet()

func spawn_bullet():
	$AudioStreamPlayer.play()
	var bullet: Area2D = bullet_scene.instantiate()
	bullet.global_position = global_position + Vector2(50, 0)
	get_parent().add_child(bullet)

func reset():
	global_position.y = 540
