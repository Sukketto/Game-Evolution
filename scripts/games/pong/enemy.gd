extends CharacterBody2D

const SPEED: float = 100.0
var ball: CharacterBody2D

var hit_chace: int = 75
var follow_ball: bool = true

func _ready() -> void:
	ball = get_parent().get_node("Ball")

func _process(delta: float) -> void:
	if follow_ball:
		global_position.y = ball.global_position.y
	else:
		global_position.y = ball.global_position.y - 90

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body is Ball:
		if (randi() % 100) < hit_chace:
			follow_ball = true
		else:
			follow_ball = false
