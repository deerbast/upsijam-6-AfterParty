extends Node2D

#To remove for production xD
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("Restart"):
		#get_tree().reload_current_scene()
		get_tree().change_scene_to_file("res://scenes/ending/ending.tscn")

func _ready() -> void:
	#à activer !!
	#pass
	$Player.blocked(5)
	$Decompte.play("new_animation")
	# Get values for every objects in group for ending screen
	for obj in get_node("objects").get_children():
		if obj.is_in_group("Object"):
			Global.total_possible_score += (obj.masse + 1) * 3 #Modifier 

func _on_decompte_animation_finished(_anim_name: StringName) -> void:
	#Game has started, player can move
	#$EndOfTime.start(30)
	pass

func _on_end_of_time_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/ending/ending.tscn")
