extends Node2D

var returning_to_main_menu = false

# Begin at main menu
func _ready():
	get_tree().paused = true
	$MainMenu/MarginContainer/VBoxContainer/PlayButton.grab_focus()
	$RightSide/Viewport.world_2d = $LeftSide/Viewport.world_2d
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	if $AnimationPlayer.current_animation == "intro":
		if Input.is_action_just_pressed("ui_accept"):
			if $AnimationPlayer.playback_speed > 0:
				$AnimationPlayer.playback_speed = 8
			else:
				$AnimationPlayer.playback_speed = -8
	
	if get_tree().paused:
		$Clock/Label.text = "%4.2f" % $LeftSide/Viewport/Game/GameTimer.wait_time
	else:
		$Clock/Label.text = "%4.2f" % $LeftSide/Viewport/Game/GameTimer.time_left
				

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
		$MainMenu/MarginContainer/VBoxContainer/SettingsButton.grab_focus()
	
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

func _on_Game_finished():
	$Summary.visible = true

# Show mainmenu when doing outro
func intro_start():
	if returning_to_main_menu:
		returning_to_main_menu = false
		$MainMenu.visible = true
		$MainMenu/MarginContainer/VBoxContainer/PlayButton.grab_focus()
		$MainMenu/AnimationPlayer.play("fade_in")
		$LeftSide/Viewport/Game.reset()
	$AnimationPlayer.playback_speed = 1
	
func play_main_menu_animation():
	$MainMenu/AnimationPlayer.play("intro")
	
# Begin the game
func intro_end():
	if not returning_to_main_menu:
		$LeftSide/Viewport/Game.start()
	$AnimationPlayer.playback_speed = 1
