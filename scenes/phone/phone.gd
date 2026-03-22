extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ContinueButton.disabled = true
	$ContinueButton.position = Vector2(720,560)
	$Sonnerie_MP3.play(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	$AnimationPlayer.play("RESET")
	$AnswerButton.disabled = true
	$Sonnerie_MP3.stop()
	$MomAudio.play(0)
	$ContinueButton.position = Vector2(488,512)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$ContinueButton.disabled = false

func _on_button_2_pressed() -> void:
	$MomAudio.stop()
	get_tree().change_scene_to_file("res://scenes/upsijam_6.tscn")

func _on_sonnerie_mp_3_finished() -> void:
	$Sonnerie_MP3.play(0)
