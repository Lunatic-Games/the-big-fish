extends Node2D

signal paused  # Show pause menu
signal finished

export (int) var UNCOMMON_CHANCE = 35
export (int) var RARE_CHANCE = 10
export (int) var SUPER_RARE_CHANCE = 1

export (float) var SLOW_MO_THRESHOLD = 0.5
export (float) var SLOW_MO_SCALE = 0.25

var COMMON_CHANCE = 100 - UNCOMMON_CHANCE - RARE_CHANCE - SUPER_RARE_CHANCE

var debug = false
var DEBUG_FISH = [preload("res://fish/cthuli.tscn")]

var COMMON_FISH = [preload("res://fish/small_snout_shod.tscn"),
	preload("res://fish/sapphire_jack.tscn"),
	preload("res://fish/electric_eel.tscn")]
var UNCOMMON_FISH = [preload("res://fish/three_eyed_warbler.tscn"),
	preload("res://fish/plated_pickerel.tscn"),
	preload("res://fish/sanguine_squid.tscn")]
var RARE_FISH = [preload("res://fish/glowing_gandersnatch.tscn"),
	preload("res://fish/bearded_clam.tscn"),
	preload("res://fish/eldritch_eel.tscn")]
var SUPER_RARE_FISH = [preload("res://fish/neptunian_narfish.tscn"),
	preload("res://fish/cthuli.tscn")]



func start():
	get_tree().paused = false
	$GameTimer.start()
	spawn_fish("left")
	spawn_fish("right")


# Handle pausing
func _process(_delta):
	if Input.is_action_just_pressed("pause") and $GameTimer.time_left > SLOW_MO_THRESHOLD:
		Engine.time_scale = 1
		get_tree().paused = true
		Input.stop_joy_vibration(0)
		Input.stop_joy_vibration(1)
		emit_signal("paused")
		
	if $GameTimer.time_left <= SLOW_MO_THRESHOLD:
		Engine.time_scale = SLOW_MO_SCALE
	
func reset():
	$Water/LeftSide/Player.reset()
	$Water/RightSide/Player.reset()
	for fish in get_tree().get_nodes_in_group("fish"):
		fish.queue_free()
	$GameTimer.start()
		
func spawn_fish(side):
	var fish
	var rarity = randi() % 100
	if debug:
		fish = DEBUG_FISH[randi() % DEBUG_FISH.size()].instance()
	elif rarity < COMMON_CHANCE:
		fish = COMMON_FISH[randi() % COMMON_FISH.size()].instance()
	elif rarity < COMMON_CHANCE + UNCOMMON_CHANCE:
		fish = UNCOMMON_FISH[randi() % UNCOMMON_FISH.size()].instance()
	elif rarity < COMMON_CHANCE + UNCOMMON_CHANCE + RARE_CHANCE:
		fish = RARE_FISH[randi() % RARE_FISH.size()].instance()	
	else:
		fish = SUPER_RARE_FISH[randi() % SUPER_RARE_FISH.size()].instance()
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
	get_tree().paused = true
	emit_signal("finished")
	Engine.time_scale = 1
