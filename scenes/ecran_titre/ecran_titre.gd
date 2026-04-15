extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("new_animation")
	
	var language = "en"
	# Load here language from the user settings file
	if language == "en":
		var preferred_language = OS.get_locale_language()
		TranslationServer.set_locale(preferred_language)
	else:
		TranslationServer.set_locale(language)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/phone/phone.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ecran_options/options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play(20.9)
