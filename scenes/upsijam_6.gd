extends Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("Restart"):
		get_tree().reload_current_scene()
