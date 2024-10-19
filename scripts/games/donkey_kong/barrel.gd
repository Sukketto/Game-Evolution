class_name Barrel extends CharacterBody2D

var force: int

var go_down: bool = false

func _process(delta: float) -> void:
	
	if !go_down:
		if !is_on_floor():
			velocity += get_gravity() * delta
		$CollisionShape2D.disabled = false
		velocity.x = force
	else:
		$CollisionShape2D.disabled = true
		force = 300 if force == -300 else -300
		velocity.x = 0
		velocity.y = 300
	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.rotation < 0:
		force = -300
		$AnimatedSprite2D.flip_h = true
	elif body.rotation > 0:
		force = 300
		$AnimatedSprite2D.flip_h = false

func _on_hittable_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		call_deferred("restart")

func restart():
	get_tree().reload_current_scene()

func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("movement")
