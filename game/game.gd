extends Node2D

signal paused  # Show pause menu
signal scrolled_down  # Show divider
signal scrolled_togther  # Hide divider
signal scrolled_up  # Show main menu

export (String) var side = ""

const HOOK_DEPTH = 165
var hook_scene = preload("res://hook/hook.tscn")
var fish_scene = preload("res://fish/fish.tscn")
var side_instance
var reversing_scroll = false
var casting = false
var line_cast = false

# Set camera position and remove unneeded assets
func _ready():
	if side == "left":
		side_instance = get_node("Water/LeftSide")
	elif side == "right":
		side_instance = get_node("Water/RightSide")
		
	$AnimationPlayer.play(side + "_scroll_down", -1, 0)
	
	if side == "left":
		$Water/RightSide.queue_free()
	elif side == "right":
		$Water/LeftSide.queue_free()
		
	spawn_fish()


# Handle pausing
func _process(_delta):
	print("Paused: ", get_tree().paused)
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		emit_signal("paused")
		
	if side_action_pressed("cast") and !line_cast:
		side_instance.get_node("CastBar").value += 1
		casting = true
		
	if side_action_just_released("cast") and casting and !line_cast:
		casting = false
		line_cast = true
		var prog_bar = side_instance.get_node("CastBar")
		
		var hook = hook_scene.instance()
		hook.position = prog_bar.rect_position
		hook.position.x += prog_bar.rect_size.x * prog_bar.value / prog_bar.max_value
		hook.position.y += HOOK_DEPTH
		side_instance.add_child(hook)
		
		prog_bar.value = 0

func spawn_fish():
	line_cast = false
	var fish = fish_scene.instance()
	fish.position = side_instance.get_node("FishArea/SpawnPosition").position
	fish.connect("caught", self, "spawn_fish")
	side_instance.get_node("FishArea").add_child(fish)
	
func side_action_pressed(action):
	return Input.is_action_pressed(action + "_" + side)
	
func side_action_just_pressed(action):
	return Input.is_action_just_pressed(action + "_" + side)
	
func side_action_just_released(action):
	return Input.is_action_just_released(action + "_" + side)
	
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
	if not reversing_scroll:
		get_tree().paused = false
	
	
	
