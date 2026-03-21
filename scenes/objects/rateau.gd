extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.set_frame_and_progress(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	#print("Player in rateau")
	if body.is_in_group("Player"):
		print("Player in rateau")
		$AudioStreamPlayer.play(0)
		$AnimatedSprite2D.play("default")
		body.blocked(1)

func _on_animated_sprite_2d_animation_looped() -> void:
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.set_frame_and_progress(3,0)
	await get_tree().create_timer(1).timeout
	$AnimatedSprite2D.set_frame_and_progress(0,0)
	
