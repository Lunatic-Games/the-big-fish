extends Node2D

var returning_to_main_menu = false

# Begin at main menu
func _ready():
	get_tree().paused = true
	$MainMenu/VBoxContainer/PlayButton.grab_focus()
	$RightSide/Viewport.world_2d = $LeftSide/Viewport.world_2d
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if $AnimationPlayer.current_animation == "intro":
		if Input.is_action_just_pressed("ui_accept"):
			if $AnimationPlayer.playback_speed > 0:
				$AnimationPlayer.playback_speed = 8
			else:
				$AnimationPlayer.playback_speed = -8
				

# Start intro transition
func _on_play_game():
	$AnimationPlayer.play("intro", 0, 1)

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
	returning_to_main_menu = true
	get_tree().paused = true
	$AnimationPlayer.play("intro", 0, -2, true)

# Game has resumed
func _on_continue_game():
	pass

# Show pause menu
func _on_Game_paused():
	$PauseMenu.visible = true
	$PauseMenu.ignore_pause = true
	$PauseMenu/MarginContainer/VBoxContainer/ContinueButton.grab_focus()

# Show mainmenu when doing outro
func intro_start():
	if returning_to_main_menu:
		returning_to_main_menu = false
		$MainMenu.visible = true
		$MainMenu/VBoxContainer/PlayButton.grab_focus()
	$AnimationPlayer.playback_speed = 1
	
# Begin the game
func intro_end():
	if not returning_to_main_menu:
		$LeftSide/Viewport/Game.start()
	$AnimationPlayer.playback_speed = 1
