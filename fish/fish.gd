extends Area2D

signal caught

export (String) var side
export (int) var SPEED = 50
export (int) var RUN_AWAY_SPEED = 75
export (Vector2) var TEXTURE_SIZE

var on_hook = false
var shown_button
var velocity = Vector2(1, 0)
var combo_angle = [0, 0]

const VERTICAL_MAX = 0.45  # Vertical movement will be in range (-VM, VM)
const BUTTONS = ["AButton", "BButton", "XButton", "YButton"]
const HOOK_SIGHT_RANGE = 400
const ANGLE_RANGE = PI / 4
const INNER_INDICATOR_DIST = 10
const OUTER_INDICATOR_DIST = 40

# Start with a random velocity
func _ready():
	randomize()
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
		var area_extents = area.shape.extents - TEXTURE_SIZE / 2
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
		$ShadowSprite.flip_h = velocity.x < 0
	
# Get a random vertical and horizontal velocity
func random_velocity():
	var vertical = rand_range(-0.45, 0.45)
	var horizontal = randi() % 2
	if horizontal == 0:
		horizontal = -1
	$ShadowSprite.flip_h = horizontal < 0
	velocity = Vector2(horizontal, vertical)

func hooked():
	on_hook = true
	$ButtonPopupTimer.start()
	$DirectionTimer.stop()
	velocity.y = 0
	if side == "left":
		velocity.x = 1
	elif side == "right":
		velocity.x = -1
	$ShadowSprite.flip_h = velocity.x < 0
		
func display_combination():
	shown_button = BUTTONS[randi() % 4]
	get_node(shown_button).visible = true
	
	combo_angle[0] = rand_range(-PI, PI)
	combo_angle[1] = combo_angle[0] + ANGLE_RANGE
	if combo_angle[1] > PI:
		combo_angle[1] = -PI + (combo_angle[1] - PI)
	update_range_indicator()
	$RangeIndicator.visible = true
	
func update_range_indicator():
	var p1 = Vector2(cos(combo_angle[0]) * INNER_INDICATOR_DIST,
		sin(combo_angle[0]) * INNER_INDICATOR_DIST) + $AButton.position
	var p2 = Vector2(cos(combo_angle[0]) * OUTER_INDICATOR_DIST,
		sin(combo_angle[0]) * OUTER_INDICATOR_DIST) + $AButton.position
	var p3 = Vector2(cos(combo_angle[1]) * OUTER_INDICATOR_DIST,
		sin(combo_angle[1]) * OUTER_INDICATOR_DIST) + $AButton.position
	var p4 = Vector2(cos(combo_angle[1]) * INNER_INDICATOR_DIST,
		sin(combo_angle[1]) * INNER_INDICATOR_DIST) + $AButton.position
	$RangeIndicator.polygon[0] = p1
	$RangeIndicator.polygon[1] = p2
	$RangeIndicator.polygon[2] = p3
	$RangeIndicator.polygon[3] = p4
	
func reel_in(amount):
	if shown_button:
		return
	if side == "left":
		position.x -= amount
	elif side == "right":
		position.x += amount
		
func catch():
	queue_free()
	emit_signal("caught")
	
func _on_ButtonPopupTimer_timeout():
	display_combination()
	
func test_combination(button, angle):
	if button == shown_button and angle_in_range(angle):
		get_node(shown_button).visible = false
		shown_button = null
		$ButtonPopupTimer.start()
		$RangeIndicator.visible = false
	
func angle_in_range(angle):
	if combo_angle[1] > -PI and combo_angle[0] >= PI / 2:
		return angle > combo_angle[0] or angle < combo_angle[1]
	return angle < combo_angle[1] and angle > combo_angle[0]

func get_mouth_position():
	var pos = global_position
	if $ShadowSprite.flip_h:
		pos.x -= TEXTURE_SIZE.x / 2
	else:
		pos.x += TEXTURE_SIZE.x / 2
	return pos
