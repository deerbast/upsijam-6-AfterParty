extends Node2D

func _ready() -> void:
	#à activer !!
	#pass
	$Player.blocked(5)
	$Decompte.play("new_animation")
	$EndOfTime.start(30)
	$EndOfTime.stop() 
	# Get values for every objects in group for ending screen
	Global.score = 0
	Global.send = false
	Global.total_possible_score = 0
	for obj in get_node("objects").get_children():
		if obj.is_in_group("Object"):
			Global.total_possible_score += (obj.masse + 1) * 3 #Modifier 
	$Player/CanvasLayer/ProgressBar.max_value = Global.total_possible_score

func _process(_delta: float) -> void:
	var time = 30
	if !$EndOfTime.is_stopped():
		time = int($EndOfTime.time_left)
	$Player/CanvasLayer/TempsRestant.text = "%ss" % time
	$Player/CanvasLayer/ProgressBar.value = Global.score/Global.total_possible_score * 100.0

func _on_decompte_animation_finished(_anim_name: StringName) -> void:
	#Game has started, player can move
	$EndOfTime.start(30)
	#pass
	
func on_decompte_beep():
	$BeepPlayer.play()
	
func on_decompte_beep_final():
	$BeepFinal.play()
	
func on_start_music():
	$AudioStreamPlayer.play(0)

func _on_end_of_time_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/ending/ending.tscn")
