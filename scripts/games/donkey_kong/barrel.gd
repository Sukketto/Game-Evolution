extends CharacterBody2D

var force: int

func _process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta
	
	velocity.x = force
	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.rotation < 0:
		force = -300
	elif body.rotation > 0:
		force = 300
	
	if body is Player:
		get_tree().reload_current_scene()
