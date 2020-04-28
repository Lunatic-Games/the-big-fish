extends Sprite

export (String) var side
export (bool) var idle = true
export (bool) var powering_cast = false
export (bool) var line_cast = false

const MIN_CAST_DISTANCE = 20
const MAX_CAST_DISTANCE = 250
const CHARGE_RATE = 100
const AXIS_THRESHOLD = 0.9
const REEL_SPEED = 750
const BOBBER_PULL = 3

var casting_charge = MIN_CAST_DISTANCE
var device_id
var last_reel_rot = null
var fish_on_line = null

func _ready():
	if side == "left":
		device_id = 0
	elif side == "right":
		device_id = 1
	
func _physics_process(delta):
	if idle and Input.is_action_just_pressed("cast_" + side):
		$AnimationPlayer.play("cast_start")
		
	if powering_cast and !Input.is_action_pressed("cast_" + side):
		$AnimationPlayer.play("cast")
		
	if powering_cast:
		increase_cast_distance(delta)
		
	if fish_on_line:
		move_bobber(delta * BOBBER_PULL)
		handle_reeling(delta)
		
	if line_cast:
		track_line()
		
	
func increase_cast_distance(delta):
	casting_charge += CHARGE_RATE * delta
	casting_charge = min(casting_charge, MAX_CAST_DISTANCE)
	var diff = MAX_CAST_DISTANCE - MIN_CAST_DISTANCE
	if casting_charge > diff * 3 / 4:
		Input.start_joy_vibration(device_id, 1, 0.5, 0)
	elif casting_charge > diff * 1 / 4:
		Input.start_joy_vibration(device_id, 1, 0, 0)
		
func track_line():
	$FishingLine.points[0] = $RodTip.position
	$FishingLine.points[1] = $Bobber.position
	$FishingLine.points[1].y -= 8
	$HookLine.points[0] = $Bobber.position
	$HookLine.points[0].y += 16
	$HookLine.points[1] = $Hook.position
	$HookLine.points[1].y -= 4
		

func handle_reeling(delta):
	var horiz = Input.get_joy_axis(device_id, JOY_AXIS_0)
	if horiz == 0:
		horiz = 0.0001
	var vert = Input.get_joy_axis(device_id, JOY_AXIS_1)
	if abs(horiz) > AXIS_THRESHOLD or abs(vert) > AXIS_THRESHOLD:
		var angle = atan2(vert, horiz)
		if last_reel_rot == null or (last_reel_rot < -1 and angle > 1):
			pass
		elif angle > last_reel_rot:
			var diff = angle - last_reel_rot
			fish_on_line.reel_in(diff * delta * REEL_SPEED)
		else:
			last_reel_rot = null
		last_reel_rot = angle
	else:
		last_reel_rot = null
	
func move_bobber(amount):
	var dir_to_fish = fish_on_line.global_position - $RodTip.global_position
	var height_diff = $Bobber.position.y - $RodTip.position.y
	var adj = height_diff / tan(dir_to_fish.angle())
	if side == "right":
		adj *= -1
	var movement = adj + $RodTip.position.x - $Bobber.position.x
	$Bobber.position.x += amount * movement
	
func cast_line():
	$Bobber.position = $BobberStart.position
	$Bobber.position.x += casting_charge
	$Hook.position = $Bobber.position
	$Hook.rotation = 0
	$Hook.position.y += 100
	casting_charge = MIN_CAST_DISTANCE
	Input.stop_joy_vibration(device_id)

func _on_fish_hooked(_fish):
	$AnimationPlayer.play("reeling")
	fish_on_line = _fish
	
func _on_CatchArea_entered(area):
	if area.is_in_group("fish"):
		area.catch()
		fish_on_line = null
		$Hook.hooked_fish = null
		$AnimationPlayer.play("idle")
