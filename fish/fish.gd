extends Area2D

signal caught

var on_hook = false
var buttons_pressed = 0
var shown_button
var velocity = Vector2(-0.75, 0)
var last_movement = Vector2()  # Undo last movement on exiting area

const VERTICAL_MAX = 0.45  # Vertical movement will be in range (-VM, VM)
const SPEED = 50  # Multiplies velocity
const BUTTONS = ["AButton", "BButton", "XButton", "YButton"]
const BUTTONS_TO_CATCH = 3

# Start with a random velocity
func _ready():
	random_velocity()

# Move with velocity
func _physics_process(delta):
	last_movement = velocity * delta * SPEED
	position += last_movement
	
	if shown_button:
		if Input.is_action_just_pressed("a_button_left") and shown_button == "AButton":
			correct_button_pressed(shown_button)
		if Input.is_action_just_pressed("b_button_left") and shown_button == "BButton":
			correct_button_pressed(shown_button)
		if Input.is_action_just_pressed("x_button_left") and shown_button == "XButton":
			correct_button_pressed(shown_button)
		if Input.is_action_just_pressed("y_button_left") and shown_button == "YButton":
			correct_button_pressed(shown_button)
			
		

# Change movement
func _on_DirectionTimer_timeout():
	random_velocity()

# Turn back
func _on_Fish_area_exited(area):
	if !area.is_in_group("fish_area"):
		return
		
	position -= last_movement
	
	var area_width = area.get_node("CollisionShape2D").shape.get_extents().x * 2
	var area_height = area.get_node("CollisionShape2D").shape.get_extents().y * 2
	if position.x > area_width / 2:
		velocity.x *= -1
	if position.x < -area_width / 2:
		velocity.x *= -1
	if position.y < -area_height / 2:
		velocity.y *= -1
	if position.y > area_height / 2:
		velocity.y *= -1
	$Sprite.flip_h = velocity.x > 0
	$DirectionTimer.call_deferred("start")
	
# Get a random vertical and horizontal velocity
func random_velocity():
	#var vertical = rand_range(-0.45, 0.45)
	var vertical = 0
	var horizontal = randi() % 2
	if horizontal == 0:
		horizontal = -1
	$Sprite.flip_h = horizontal > 0
	velocity = Vector2(horizontal, vertical)

func _on_Fish_area_entered(area):
	if area.is_in_group("hook"):
		on_hook = true
		display_button()
		
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
	buttons_pressed += 1
	if buttons_pressed == BUTTONS_TO_CATCH:
		$AnimationPlayer.play("fade_out")
	else:
		display_button()
		
func gone():
	queue_free()
	emit_signal("caught")
	
