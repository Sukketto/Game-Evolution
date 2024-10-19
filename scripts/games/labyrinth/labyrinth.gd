extends Node3D

const INCLINATION: float = 1.0
const MAX_ROTATION: float = 45.0

var ball_on_floor: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		$Ground.rotation_degrees.z -= INCLINATION
	elif Input.is_action_pressed("right"):
		$Ground.rotation_degrees.z += INCLINATION
	elif Input.is_action_pressed("up"):
		$Ground.rotation_degrees.x += INCLINATION
	elif Input.is_action_pressed("down"):
		$Ground.rotation_degrees.x -= INCLINATION
	else:
		$Ground.rotation_degrees = lerp($Ground.rotation_degrees, Vector3.ZERO, 0.03)
	
	$Ground.rotation_degrees.z = clamp($Ground.rotation_degrees.z, -MAX_ROTATION, MAX_ROTATION)
	$Ground.rotation_degrees.x = clamp($Ground.rotation_degrees.x, -MAX_ROTATION, MAX_ROTATION)
	
	if ball_on_floor == false:
		$Camera3D.global_position.y -= 0.5
		$GroundFar.visible = true
		$Camera3D.global_position.x = $Ball.global_position.x
		$Camera3D.global_position.z = $Ball.global_position.z
		await get_tree().create_timer(10.0).timeout
		get_tree().reload_current_scene()

func _on_falling_area_body_entered(body: Node3D) -> void:
	ball_on_floor = false
