extends Node2D

signal paused  # Show pause menu
signal scrolled_down  # Show divider
signal scrolled_togther  # Hide divider
signal scrolled_up  # Show main menu

var reversing_scroll = false
export (String) var side = ""


func _ready():
	$AnimationPlayer.play(side + "_scroll_down", -1, 0)
	if side == "left":
		$Water/RightArea.queue_free()
	elif side == "right":
		$Water/LeftArea.queue_free()
		
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		emit_signal("paused")

func scrolled_to_bottom():
	if reversing_scroll:
		return
	emit_signal("scrolled_down")
	$AnimationPlayer.play(side + "_scroll_away")
	
func reverse_animation():
	$AnimationPlayer.play_backwards(side + "_scroll_away")
	reversing_scroll = true
	
func scrolled_togther():
	if not reversing_scroll:
		return
	$AnimationPlayer.play_backwards(side + "_scroll_down")
	emit_signal("scrolled_togther")
		
func scrolled_to_top():
	if not reversing_scroll:
		return
	emit_signal("scrolled_up")
	reversing_scroll = false
	
func scrolled_away():
	get_tree().paused = false
	
	
