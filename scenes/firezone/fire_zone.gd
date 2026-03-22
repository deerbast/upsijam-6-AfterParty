extends Area2D

const BURN_S = 0.4

func _ready() -> void:
	$AnimatedSprite2D.play("default")

# Will delete every body on the same layer!
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Object"):
		Global.score += (body.masse + 1) * 3
		body.remove_from_group("Object")
		burn_object(body)
		
func burn_object(body: Node2D):
	$Burn.play()
	var tween = create_tween()
	body.reparent(self)
	tween.parallel().tween_property(body, "position", Vector2.ZERO, BURN_S)
	tween.parallel().tween_property(body, "scale", Vector2(0.1, 0.1), BURN_S)
	tween.parallel().tween_property(body, "modulate:a", 0.0, BURN_S)
	tween.parallel().tween_property(body, "rotation", randf_range(-1, 1), BURN_S)
	await tween.finished
	body.queue_free()
