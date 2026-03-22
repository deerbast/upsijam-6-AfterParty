extends Area2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")

# Will delete every body on the same layer!
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Object"):
		Global.score += (body.masse + 1) * 3
		body.queue_free()
		$Burn.play()
