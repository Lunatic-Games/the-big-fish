extends ColorRect

signal continue_game
signal go_to_settings
signal go_to_main_menu

var ignore_pause = true

func _process(delta):
	if !visible:
		return
	if Input.is_action_just_pressed("pause"):
		if ignore_pause:
			ignore_pause = false
		else:
			_on_ContinueButton_pressed()
	if Input.is_action_just_pressed("ui_cancel"):
		_on_ContinueButton_pressed()
		
# Unpause game
func _on_ContinueButton_pressed():
	visible = false
	get_tree().paused = false
	emit_signal("continue_game")

# Go to settings
func _on_SettingsButton_pressed():
	$MarginContainer.visible = false
	emit_signal("go_to_settings")

# Unpause game
func unpause():
	_on_ContinueButton_pressed()

# Transition to main menu
func _on_ReturnToMainMenuButton_pressed():
	visible = false
	emit_signal("go_to_main_menu")
