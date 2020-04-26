extends Node2D

signal paused  # Show pause menu
signal scrolled_down  # Show divider
signal scrolled_togther  # Hide divider
signal scrolled_up  # Show main menu

var reversing_scroll = false
export (String) var side = ""


# Set camera position and remove unneeded assets
func _ready():
	$AnimationPlayer.play(side + "_scroll_down", -1, 0)
	if side == "left":
		$Water/RightArea.queue_free()
	elif side == "right":
		$Water/LeftArea.queue_free()


# Handle pausing
func _process(_delta):
	if !get_tree().paused and Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		emit_signal("paused")

# Begin to scroll away
func scrolled_to_bottom():
	if reversing_scroll:
		return
	emit_signal("scrolled_down")
	$AnimationPlayer.play(side + "_scroll_away")
	

# Begin reverse scroll
func reverse_animation():
	$AnimationPlayer.play_backwards(side + "_scroll_away")
	reversing_scroll = true
	
# Begin scrollling back up when doing reverse scroll
func scrolled_togther():
	if not reversing_scroll:
		return
	$AnimationPlayer.play_backwards(side + "_scroll_down")
	emit_signal("scrolled_togther")
		
# Show main menu again
func scrolled_to_top():
	if not reversing_scroll:
		return
	emit_signal("scrolled_up")
	reversing_scroll = false
	
# Begin playing game
func scrolled_away():
	get_tree().paused = false
	
	
