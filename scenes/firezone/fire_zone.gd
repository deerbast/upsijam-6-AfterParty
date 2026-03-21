extends Area2D

# Will delete every body on the same layer!
func _on_body_entered(body: Node2D) -> void:
	if body.masse != null:
		Global.score += body.masse
	body.queue_free()
	
