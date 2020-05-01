extends Control

signal play_again
signal return_to_main_menu
export (int) var SCORE_INCREASE_RATE = 1000

var playing_again
var left_fish_caught = []
var right_fish_caught = []
var left_fish_index = 0
var right_fish_index = 0
var left_score = 0
var right_score = 0
var left_score_goal = 0
var right_score_goal = 0


func _process(delta):
	if Input.is_action_just_pressed("cast_left"):
		if $LeftFishAnimator.is_playing():
			$LeftFishAnimator.advance($LeftFishAnimator.current_animation_length)
		if left_fish_index < len(left_fish_caught):
			$TextureRect/Summaries/Left/Prompt.visible = false
			var fish = left_fish_caught[left_fish_index]
			left_score_goal += fish.POINTS
			left_fish_index += 1
			add_fish(fish, $TextureRect/Summaries/Left/Stack, 
				$TextureRect/Summaries/Left/Current, $LeftFishAnimator)
			if (left_fish_index == len(left_fish_caught) 
					and right_fish_index == len(right_fish_caught)):
				$TextureRect/Buttons.visible = true
				$FocusDefault.grab_focus()
			
	if Input.is_action_just_pressed("cast_right"):
		if $RightFishAnimator.is_playing():
			$RightFishAnimator.advance($RightFishAnimator.current_animation_length)
		if right_fish_index < len(right_fish_caught):
			$TextureRect/Summaries/Right/Prompt.visible = false
			var fish = right_fish_caught[right_fish_index]
			right_score_goal += fish.POINTS
			right_fish_index += 1
			add_fish(fish, $TextureRect/Summaries/Right/Stack,
				$TextureRect/Summaries/Right/Current, $RightFishAnimator)
			if (left_fish_index == len(left_fish_caught) 
					and right_fish_index == len(right_fish_caught)):
				$TextureRect/Buttons.visible = true
				$FocusDefault.grab_focus()
		
	if left_score < left_score_goal:
		left_score = min(left_score + int(SCORE_INCREASE_RATE * delta), left_score_goal)
		$TextureRect/Summaries/Left/Score.text = str(left_score)
	if right_score < right_score_goal:
		right_score = min(right_score + int(SCORE_INCREASE_RATE * delta), right_score_goal)
		$TextureRect/Summaries/Right/Score.text = str(right_score)

func add_fish(fish, stack, anim_sprite, animator):
	var frames = fish.get_node("FishSprite").frames
	var old_current = anim_sprite.duplicate()
	stack.add_child(old_current)
	anim_sprite.texture = frames.get_frame("default", 0)
	anim_sprite.rotation_degrees = (randi() % 90) - 45
	if randi() % 2:
		anim_sprite.flip_h = true
	animator.play("slap")
	
func game_finished(left_fish, right_fish):
	left_score = 0
	left_score_goal = 0
	right_score = 0
	right_score_goal = 0
	$TextureRect/Summaries/Left/Current.texture = null
	$TextureRect/Summaries/Right/Current.texture = null
	$TextureRect/Summaries/Left/Score.text = ""
	$TextureRect/Summaries/Right/Score.text = ""
	for node in $TextureRect/Summaries/Left/Stack.get_children():
		node.queue_free()
	for node in $TextureRect/Summaries/Right/Stack.get_children():
		node.queue_free()
	left_fish_caught = left_fish
	right_fish_caught = right_fish
	left_fish_index = 0
	right_fish_index = 0
	
func scrolled_in():
	if (left_fish_index == len(left_fish_caught) 
			and right_fish_index == len(right_fish_caught)):
		$TextureRect/Buttons.visible = true
		$FocusDefault.grab_focus()
		
	if left_fish_index < len(left_fish_caught):
		$TextureRect/Summaries/Left/Prompt.visible = true
	if right_fish_index < len(right_fish_caught):
		$TextureRect/Summaries/Right/Prompt.visible = true
	
func scrolled_out():
	if playing_again:
		emit_signal("play_again")
	else:
		emit_signal("return_to_main_menu")

func _on_PlayAgainButton_pressed():
	if !visible:
		return
	$AcceptSFX.play()
	$AnimationPlayer.play("scroll_out")
	playing_again = true


func _on_ReturnToMainMenuButton_pressed():
	if !visible:
		return
	$AcceptSFX.play()
	$AnimationPlayer.play("scroll_out")
	playing_again = false
