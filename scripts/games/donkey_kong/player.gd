class_name PlayerDK extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const LADDER_VELOCITY = 300.0

var is_on_ladder: bool = false
var take_ladder: bool = false

func _physics_process(delta: float) -> void:
	
	if !take_ladder:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
	
		# Handle jump.
		if Input.is_action_just_pressed("primary_action") and is_on_floor():
			$AudioStreamPlayer.play()
			velocity.y = JUMP_VELOCITY
		
		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if direction == 1:
			$AnimatedSprite2D.flip_h = false
		elif direction == -1:
			$AnimatedSprite2D.flip_h = true
		for h in get_children():
			if h is Hammer:
				h.scale.x = direction if direction != 0 else h.scale.x
		
	move_and_slide()
	
	if velocity.y != 0:
		$AnimatedSprite2D.play("jump")
	elif velocity.x != 0:
		$AnimatedSprite2D.play("move")
	else:
		$AnimatedSprite2D.play("idle")
	
	if is_on_ladder:
		if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
			take_ladder = true
		if take_ladder:
			$CollisionShape2D.disabled = true
			if Input.is_action_pressed("up"):
				velocity.y = -LADDER_VELOCITY
			elif Input.is_action_pressed("down"):
				velocity.y = LADDER_VELOCITY
			else:
				velocity.y = 0
	else:
		$CollisionShape2D.disabled = false
		take_ladder = false
