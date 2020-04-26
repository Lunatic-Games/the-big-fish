extends Node2D


# Begin at main menu
func _ready():
	get_tree().paused = true
	$MainMenu/VBoxContainer/PlayButton.grab_focus()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Start intro transition
func _on_play_game():
	$LeftSide/Viewport/Game/AnimationPlayer.play("left_scroll_down")
	$RightSide/Viewport/Game/AnimationPlayer.play("right_scroll_down")

# Show settings
func _go_to_settings():
	$SettingsMenu.visible = true
	$SettingsMenu/VBoxContainer/MusicContainer/HSlider.grab_focus()

# Return to previous menu
func _return_from_settings():
	if $PauseMenu.visible:
		$PauseMenu/MarginContainer.visible = true
		$PauseMenu/MarginContainer/VBoxContainer/SettingsButton.grab_focus()
	else:
		$MainMenu.visible = true
		$MainMenu/VBoxContainer/SettingsButton.grab_focus()
	
# Start outro transition
func _return_to_main_menu():
	$LeftSide/Viewport/Game.reverse_animation()
	$RightSide/Viewport/Game.reverse_animation()

# Game has resumed
func _on_continue_game():
	pass

# Show pause menu
func _on_Game_paused():
	$PauseMenu.visible = true
	$PauseMenu/MarginContainer/VBoxContainer/ContinueButton.grab_focus()

# Split screen
func _on_Game_scrolled_down():
	pass
	$Divider.visible = true

# Show main menu
func _on_Game_scrolled_up():
	$MainMenu/VBoxContainer/PlayButton.grab_focus()
	$MainMenu.visible = true

# Unsplit screen
func _on_Game_scrolled_togther():
	$Divider.visible = false
