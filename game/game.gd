extends Node2D

signal paused  # Show pause menu

var fish_scene = preload("res://fish/fish.tscn")

func start():
	get_tree().paused = false
	spawn_fish("left")
	spawn_fish("right")


# Handle pausing
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		emit_signal("paused")
	
func reset():
	$Water/LeftSide/Player/AnimationPlayer.play("idle")
	$Water/RightSide/Player/AnimationPlayer.play("idle")
	for fish in get_tree().get_nodes_in_group("fish"):
		fish.queue_free()
		
func spawn_fish(side):
	var fish = fish_scene.instance()
	var fish_area
	if side == "left":
		fish_area = $Water/LeftSide/FishArea
		fish.side = "left"
	elif side == "right":
		fish_area= $Water/RightSide/FishArea
		fish.side = "right"
	fish.position = fish_area.get_node("SpawnPosition").position
	fish.connect("caught", self, "spawn_fish", [side])
	fish_area.call_deferred("add_child", fish)
