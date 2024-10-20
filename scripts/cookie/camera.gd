extends Camera2D

# Use left,right,up,down to move the camera
func _process(delta):
	var move = Vector2.ZERO
	if Input.is_action_pressed("right"):
		move.x += 1
	if Input.is_action_pressed("left"):
		move.x -= 1
	if Input.is_action_pressed("down"):
		move.y += 1
	if Input.is_action_pressed("up"):
		move.y -= 1
	move = move.normalized() * 500 * delta
	global_position += move
