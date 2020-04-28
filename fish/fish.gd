extends Area2D

signal caught

export (String) var side
export (int) var SPEED = 50
export (int) var RUN_AWAY_SPEED = 100

var on_hook = false
var shown_button
var velocity = Vector2(1, 0)

const VERTICAL_MAX = 0.45  # Vertical movement will be in range (-VM, VM)
const BUTTONS = ["AButton", "BButton", "XButton", "YButton"]
const HOOK_SIGHT_RANGE = 400

# Start with a random velocity
func _ready():
	random_velocity()

# Move with velocity
func _physics_process(delta):
	if not on_hook:
		look_for_hook()
		
	var movement = velocity * delta
	if on_hook:
		movement *= RUN_AWAY_SPEED
	else:
		movement *= SPEED
	position += movement
	
	handle_collisions(movement)
	
	if shown_button:
		if Input.is_action_just_pressed("a_button_left") and shown_button == "AButton":
			correct_button_pressed(shown_button)
		if Input.is_action_just_pressed("b_button_left") and shown_button == "BButton":
			correct_button_pressed(shown_button)
		if Input.is_action_just_pressed("x_button_left") and shown_button == "XButton":
			correct_button_pressed(shown_button)
		if Input.is_action_just_pressed("y_button_left") and shown_button == "YButton":
			correct_button_pressed(shown_button)


func look_for_hook():
	for hook in get_tree().get_nodes_in_group("hook"):
		var diff = hook.global_position - global_position
		if hook.in_water and abs(diff.x) < HOOK_SIGHT_RANGE:
			velocity = diff.normalized()
	
# Change movement
func _on_DirectionTimer_timeout():
	random_velocity()

func handle_collisions(movement):
	
	if get_parent().is_in_group("fish_area"):
		var area = get_parent().get_node("CollisionShape2D")
		var area_extents = area.shape.extents - $Sprite.texture.get_size()/2
		if position.x > area_extents.x:
			if on_hook and side == "left":
				position -= movement
			elif side == "left" or !on_hook:
				velocity.x = -abs(velocity.x)
		elif position.x < -area_extents.x:
			if on_hook and side == "right":
				position -= movement
			elif side == "right" or !on_hook:
				velocity.x = abs(velocity.x)
		if position.y < -area_extents.y:
			velocity.y = abs(velocity.y)
		elif position.y > area_extents.y:
			velocity.y = -abs(velocity.y)
		$Sprite.flip_h = velocity.x > 0
	
# Get a random vertical and horizontal velocity
func random_velocity():
	var vertical = rand_range(-0.45, 0.45)
	var horizontal = randi() % 2
	if horizontal == 0:
		horizontal = -1
	$Sprite.flip_h = horizontal > 0
	velocity = Vector2(horizontal, vertical)

func hooked():
	on_hook = true
	$DirectionTimer.stop()
	velocity.y = 0
	if side == "left":
		velocity.x = 1
	elif side == "right":
		velocity.x = -1
	$Sprite.flip_h = velocity.x > 0
		
func display_button():
	var button
	while true:
		button = BUTTONS[randi() % 4]
		if button != shown_button:
			break
	shown_button = button
	get_node(button).visible = true
	
func correct_button_pressed(button_pressed):
	get_node(button_pressed).visible = false
	display_button()
	
func reel_in(amount):
	if side == "left":
		position.x -= amount
	elif side == "right":
		position.x += amount
		
func catch():
	queue_free()
	emit_signal("caught")
	
