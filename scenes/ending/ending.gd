extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var score = int(Global.score/Global.total_possible_score * 100.0)
	var text = "Tu as détruit {nbr}% des resources possibles."
	$Score.text = text.format({"nbr" : str(score)})
	$AnimationPlayer.play("new_animation")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/upsijam_6.tscn")
