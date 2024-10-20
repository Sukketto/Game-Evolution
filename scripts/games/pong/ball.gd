class_name Ball extends CharacterBody2D

const SPEED: float = 1500.0
var k: float = 0.0003

func _ready() -> void:
	# Imposta una velocità iniziale con lunghezza costante
	velocity = Vector2(-SPEED, randf_range(-25.0, 25.0)).normalized() * SPEED

func _process(delta: float) -> void:
	# Muovi la palla e gestisci le collisioni
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		if !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play() 
		$"../Livello".avanza(1)
		# Ottieni la normale della collisione e fai rimbalzare la palla
		var normal := collision.get_normal()
		velocity = velocity.bounce(normal)
		if collision.get_collider() is CharacterBody2D:
			var dist = position.distance_squared_to(collision.get_collider().position)
			var angle = randi_range(-dist, dist) * k
			angle = clamp(angle, -PI/4, +PI/4)
			velocity = velocity.rotated(angle)

	# Normalizza la velocità per mantenerla costante e poi moltiplica per SPEED
	velocity = velocity.normalized() * SPEED

func restart():
	await get_tree().create_timer(1.0).timeout
	global_position = Vector2(1920/2, 1080/2)
	$"../Player".global_position = Vector2(50, 540)
	velocity = Vector2.ZERO
	await get_tree().create_timer(1.0).timeout
	velocity = Vector2(-SPEED, randf_range(-25.0, 25.0)).normalized() * SPEED

func reset():
	await get_tree().create_timer(1.0).timeout
	$"../Player".global_position = Vector2(50, 540)
	$"../Enemy".global_position = Vector2(1860, 540)
	global_position = Vector2(1920/2, 1080/2)
	velocity = Vector2.ZERO
