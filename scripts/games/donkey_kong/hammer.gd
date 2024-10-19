class_name Hammer extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _on_enter_area_body_entered(body: Node2D) -> void:
	if body is PlayerDK:
		var new_parent = get_parent().get_node("Player")
		# Usa call_deferred per rimuovere il nodo
		call_deferred("move_to_new_parent", new_parent)
		$Timer.start()
		anim_player.play("hit")

func move_to_new_parent(new_parent: Node) -> void:
	# Questa funzione viene chiamata in modo differito per evitare problemi con il callback della fisica
	get_parent().remove_child(self)
	self.position = Vector2.ZERO
	new_parent.add_child(self)

func _on_hammer_texture_body_entered(body: Node2D) -> void:
	if body is Barrel:
		body.queue_free()

func _on_timer_timeout() -> void:
	queue_free()
