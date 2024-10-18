extends CharacterBody2D

var ball: CharacterBody2D

func _ready() -> void:
	ball = get_parent().get_node("Ball")

func _process(delta: float) -> void:
	global_position.y = ball.global_position.y
