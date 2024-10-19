class_name EnemyDK extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var direction: int = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity.x = direction * SPEED
	
	move_and_slide()

func _on_change_dir_timer_timeout() -> void:
	direction = -direction
	$AnimatedSprite2D.flip_h = true if direction == -1 else false
	$ChangeDirTimer.start(randi_range(1, 15))


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		call_deferred("restart")

func restart():
	get_tree().reload_current_scene()
