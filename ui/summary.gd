extends Control

signal play_again
signal return_to_main_menu

var playing_again
var left_score_goal = 0
var right_score_goal = 0

func scrolled_in():
	$TextureRect/HBoxContainer/PlayAgainButton.grab_focus()
	
func scrolled_out():
	if playing_again:
		emit_signal("play_again")
	else:
		emit_signal("return_to_main_menu")

func _on_PlayAgainButton_pressed():
	if !visible:
		return
	$AnimationPlayer.play("scroll_out")
	playing_again = true


func _on_ReturnToMainMenuButton_pressed():
	if !visible:
		return
	$AnimationPlayer.play("scroll_out")
	playing_again = false
