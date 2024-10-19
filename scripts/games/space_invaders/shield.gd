class_name Shield extends StaticBody2D

var state: int = 3

func _process(delta: float) -> void:
	match state:
		3:
			modulate = Color("ffffff")
		2:
			modulate = Color("ffffff80")
		1:
			modulate = Color("ffffff40")
	
	if state <= 0:
		queue_free()
