extends Area2D

var velocity = Vector2(-0.75, 0)
var last_movement = Vector2()  # Undo last movement on exiting area

const VERTICAL_MAX = 0.45  # Vertical movement will be in range (-VM, VM)
const SPEED = 50  # Multiplies velocity

# Start with a random velocity
func _ready():
	random_velocity()
	
# Move with velocity
func _physics_process(delta):
	last_movement = velocity * delta * SPEED
	position += last_movement

# Change movement
func _on_DirectionTimer_timeout():
	random_velocity()

# Turn back
func _on_Fish_area_exited(area):
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
	var vertical = rand_range(-0.45, 0.45)
	var horizontal = randi() % 2
	if horizontal == 0:
		horizontal = -1
	$Sprite.flip_h = horizontal > 0
	velocity = Vector2(horizontal, vertical)
