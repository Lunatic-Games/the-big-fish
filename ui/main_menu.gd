extends Control

signal play_game
signal go_to_settings
	
# Begin game intro
func _on_PlayButton_pressed():
	if $AnimationPlayer.current_animation != "fade_out":
		$AcceptSFX.play()
	$AnimationPlayer.play("fade_out")
	
func _process(_delta):
	if visible and Input.is_action_just_pressed("ui_accept"):
		if $AnimationPlayer.current_animation == "intro":
			$AnimationPlayer.advance($AnimationPlayer.current_animation_length)
		
func faded_out():
	visible = false
	emit_signal("play_game")

# Go to settings
func _on_SettingsButton_pressed():
	$AcceptSFX.play()
	emit_signal("go_to_settings")
	visible = false

# Exit game
func _on_ExitButton_pressed():
	$ExitSFX.play()
	$AnimationPlayer.play("exit")
	
func quit_game():
	get_tree().quit()
	
