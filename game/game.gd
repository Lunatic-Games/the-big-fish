extends Node2D

signal paused  # Show pause menu
signal finished

export (int) var UNCOMMON_CHANCE = 30
export (int) var RARE_CHANCE = 10

var COMMON_CHANCE = 100 - UNCOMMON_CHANCE - RARE_CHANCE
var COMMON_FISH = [preload("res://fish/small_snout_shod.tscn"),
	preload("res://fish/sapphire_jack.tscn")]
var UNCOMMON_FISH = [preload("res://fish/three_eyed_warbler.tscn")]
var RARE_FISH = [preload("res://fish/glowing_gandersnatch.tscn")]

func start():
	get_tree().paused = false
	$GameTimer.start()
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
	$GameTimer.stop()
		
func spawn_fish(side):
	var fish
	var rarity = randi() % 100
	if rarity < COMMON_CHANCE:
		fish = COMMON_FISH[randi() % COMMON_FISH.size()].instance()
	elif rarity < COMMON_CHANCE + UNCOMMON_CHANCE:
		fish = UNCOMMON_FISH[randi() % UNCOMMON_FISH.size()].instance()
	else:
		fish = RARE_FISH[randi() % RARE_FISH.size()].instance()	
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


func _on_GameTimer_timeout():
	return
	get_tree().paused = true
	emit_signal("finished")
