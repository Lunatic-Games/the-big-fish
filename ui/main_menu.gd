extends MarginContainer

signal play_game
signal go_to_settings
	
# Begin game intro
func _on_PlayButton_pressed():
	emit_signal("play_game")
	visible = false

# Go to settings
func _on_SettingsButton_pressed():
	emit_signal("go_to_settings")
	visible = false

# Exit game
func _on_ExitButton_pressed():
	get_tree().quit()
