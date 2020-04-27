extends Node2D

signal paused  # Show pause menu

var fish_scene = preload("res://fish/fish.tscn")

func start():
	get_tree().paused = false
	spawn_fish($Water/LeftSide/FishArea)
	spawn_fish($Water/RightSide/FishArea)


# Handle pausing
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		emit_signal("paused")
	
func spawn_fish(fish_area):
	var fish = fish_scene.instance()
	fish.position = fish_area.get_node("SpawnPosition").position
	fish.connect("caught", self, "spawn_fish", [fish_area])
	fish_area.add_child(fish)
