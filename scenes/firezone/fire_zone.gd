extends Area2D

# Will delete every body on the same layer!
func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
	
