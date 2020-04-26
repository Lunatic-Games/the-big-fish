extends MarginContainer

signal play_game
signal go_to_settings
	
func _on_PlayButton_pressed():
	emit_signal("play_game")
	visible = false

func _on_SettingsButton_pressed():
	emit_signal("go_to_settings")
	visible = false

func _on_ExitButton_pressed():
	get_tree().quit()
