extends Area2D

const BURN_S = 0.4

@onready var burnout = $BurnAnim

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	burnout.visible = false

# Will delete every body on the same layer!
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Object"):
		Global.score += (body.masse + 1) * 3
		body.remove_from_group("Object")
		burn_object(body)
		
func burn_object(body: Node2D) -> void:
	if not is_instance_valid(body):
		return
	$Burn.play()
	burnout.visible = true
	burnout.play("burnout")
	var tween = create_tween()
	tween.parallel().tween_property(body, "global_position", global_position, BURN_S)
	tween.parallel().tween_property(body, "scale", Vector2(0.1, 0.1), BURN_S)
	tween.parallel().tween_property(body, "modulate:a", 0.0, BURN_S)
	tween.parallel().tween_property(body, "rotation", randf_range(-1, 1), BURN_S)
	await tween.finished
	if is_instance_valid(body): body.queue_free()

func _on_burnout_anim_finished() -> void:
	burnout.visible = false
