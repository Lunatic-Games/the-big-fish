extends Control

signal play_game
signal go_to_settings
	
# Begin game intro
func _on_PlayButton_pressed():
	$AnimationPlayer.play("fade_out")
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if $AnimationPlayer.current_animation == "intro":
			$AnimationPlayer.advance($AnimationPlayer.current_animation_length)
		
func faded_out():
	visible = false
	emit_signal("play_game")

# Go to settings
func _on_SettingsButton_pressed():
	emit_signal("go_to_settings")
	visible = false

# Exit game
func _on_ExitButton_pressed():
	get_tree().quit()
