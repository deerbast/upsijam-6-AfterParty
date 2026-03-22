extends Control

func _on_send_to_leaderboard_pressed() -> void:
	if !Global.send:
		$SendToLeaderboard.disabled = true
		Global.send = true
		var player_name = $PlayerName.text
		var score = "%.2f" % (Global.score/Global.total_possible_score * 100.0)
		var sw_result: Dictionary = await SilentWolf.Scores.save_score(player_name, score).sw_save_score_complete
		print("Score persisted successfully: " + str(sw_result.score_id))
		update_leaderboard()
		
func _ready() -> void:
	update_leaderboard()
	
func update_leaderboard() -> void:
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
	var leaderboard = "[table=2][cell expand][center]  Username  [/center][/cell][cell][center] Score [/center][/cell]"
	for score in sw_result.scores:
		leaderboard += "[cell expand][center] %s [/center][/cell][cell][center] %s [/center][/cell]" % [score.player_name, score.score]
	leaderboard += "[/table]"
	$RichTextLabel.text = leaderboard
	
	
