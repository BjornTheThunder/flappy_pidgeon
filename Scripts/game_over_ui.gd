extends CanvasLayer

signal restart

func _on_continue_button_pressed() -> void:
	$SelectSound.play()
	$AnimationPlayer.play("RESET")
	restart.emit()

func play_appear_animation() -> void:
	show()
	%ScoreLabel.hide()
	$AnimationPlayer.play("new_animation")

func play_score_animation() -> void:
	if %ScoreLabel.text == %BestScoreLabel.text:
		$ConfettiParticles.emitting = true
		$ConfettiParticles2.emitting = true
		$ConfettiParticles3.emitting = true
		$ConfettiParticles4.emitting = true
		$ApplauseSound.play()
	
	%ScoreLabel.show()
	var current_score = int(%ScoreLabel.text)
	var animated_score = 0
	
	while animated_score < current_score:
		animated_score += 1
		if animated_score > current_score:
			animated_score = current_score
		
		await get_tree().create_timer(0.03).timeout
		$ScoreSound.play()
		$AnimationPlayer.play("score_animation")
		%ScoreLabel.text = str(animated_score)
