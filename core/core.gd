extends Node2D

var returning_to_main_menu = false

# Begin at main menu
func _ready():
	get_tree().paused = true
	$MainMenu/MarginContainer/VBoxContainer/SinglePlayerButton.grab_focus()
	$RightSide/Viewport.world_2d = $LeftSide/Viewport.world_2d
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	if ($AnimationPlayer.current_animation == "intro" || 
			$AnimationPlayer.current_animation == "intro_single"):
		if Input.is_action_just_pressed("ui_accept"):
			if $AnimationPlayer.playback_speed > 0:
				$AnimationPlayer.playback_speed = 8
			else:
				$AnimationPlayer.playback_speed = -8
	
	if !get_tree().paused:
		$Clock/Label.text = str(int($LeftSide/Viewport/Game/GameTimer.time_left))
				

# Start intro transition
func _on_play_game():
	if $MainMenu.single_player:
		$AnimationPlayer.play("intro_single", 0, 1)
		$LeftSide/Viewport/Game/Water/RightSide/Player.set_process(false)
		$SummaryMenu/TextureRect/Summaries/Right.visible = false
	else:
		$AnimationPlayer.play("intro", 0, 1)
		$LeftSide/Viewport/Game/Water/RightSide/Player.set_process(true)
		$SummaryMenu/TextureRect/Summaries/Right.visible = true
	$AnimationPlayer.queue("countdown")

# Show settings
func _go_to_settings():
	$SettingsMenu.visible = true
	$SettingsMenu/VBoxContainer/MusicContainer/HSlider.grab_focus()

# Return to previous menu
func _return_from_settings():
	if $PauseMenu.visible:
		$PauseMenu.ignore_back = true
		$PauseMenu/MarginContainer.visible = true
		$PauseMenu/MarginContainer/VBoxContainer/SettingsButton.grab_focus()
	else:
		$MainMenu.visible = true
		$MainMenu/MarginContainer/VBoxContainer/SettingsButton.grab_focus()
	
# Start outro transition
func _return_to_main_menu():
	$InGameMusic.stream_paused = false
	$GameMusicFader.play("fade_out")
	returning_to_main_menu = true
	$Countdown.visible = false
	$AnimationPlayer.playback_active = true
	get_tree().paused = true
	if $MainMenu.single_player:
		$AnimationPlayer.play("intro_single", 0, -2, true)
	else:
		$AnimationPlayer.play("intro", 0, -2, true)

# Game has resumed
func _on_continue_game():
	$AnimationPlayer.playback_active = true
	$InGameMusic.stream_paused = false

# Show pause menu
func _on_Game_paused():
	$InGameMusic.stream_paused = true
	$PauseMenu.visible = true
	$PauseMenu.ignore_pause = true
	$AnimationPlayer.playback_active = false
	$PauseMenu/MarginContainer/VBoxContainer/ContinueButton.grab_focus()

func _on_Game_finished():
	$SummaryMenu.visible = true
	$SummaryMenu.game_finished($LeftSide/Viewport/Game/Water/LeftSide/Player.fish_caught,
		$LeftSide/Viewport/Game/Water/RightSide/Player.fish_caught)
	$SummaryMenu/AnimationPlayer.play("scroll_in")
	$GameMusicFader.play("fade_out")

# Show mainmenu when doing outro
func intro_start():
	if returning_to_main_menu:
		returning_to_main_menu = false
		$MainMenu.visible = true
		$MainMenu/MarginContainer/VBoxContainer/SinglePlayerButton.grab_focus()
		$MainMenu/AnimationPlayer.play("fade_in")
		$LeftSide/Viewport/Game.reset()
	else:
		$Clock/Label.text = str(int($LeftSide/Viewport/Game/GameTimer.wait_time))
	$AnimationPlayer.playback_speed = 1
	
func play_main_menu_animation():
	$MainMenu/AnimationPlayer.play("intro")
	
# Begin the game
func intro_end():
	if not returning_to_main_menu:
		$AnimationPlayer.play("countdown")
	$AnimationPlayer.playback_speed = 1
	
func countdown_end():
	$LeftSide/Viewport/Game.start()

func _on_Summary_play_again():
	$LeftSide/Viewport/Game.reset()
	$Clock/Label.text = str(int($LeftSide/Viewport/Game/GameTimer.wait_time))
	$AnimationPlayer.play("countdown")
	
func play_slap():
	if returning_to_main_menu:
		return
	$SlapSFX.play()
	
