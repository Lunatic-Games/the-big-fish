extends Sprite

export (String) var side
export (bool) var powering_cast
export (bool) var casting = false
export (bool) var attach_line = false

const MIN_CAST_DISTANCE = 20
const MAX_CAST_DISTANCE = 250
const CHARGE_RATE = 100 # 150

onready var hook_scene = preload("res://hook/hook.tscn")

var casting_charge = MIN_CAST_DISTANCE
var device_id

func _ready():
	if side == "left":
		device_id = 0
	elif side == "right":
		device_id = 1
	
func _physics_process(delta):
	if !attach_line and Input.is_action_just_pressed("cast_" + side):
		$HookLine.visible = false
		$AnimationPlayer.play("cast_start")
		
	if powering_cast and !casting and !Input.is_action_pressed("cast_" + side):
		$AnimationPlayer.play("cast")
		
	if powering_cast:
		casting_charge += CHARGE_RATE * delta
		casting_charge = min(casting_charge, MAX_CAST_DISTANCE)
		var diff = MAX_CAST_DISTANCE - MIN_CAST_DISTANCE
		if casting_charge > diff * 3 / 4:
			Input.start_joy_vibration(device_id, 1, 0.5, 0)
		elif casting_charge > diff * 1 / 4:
			Input.start_joy_vibration(device_id, 1, 0, 0)
		
	if attach_line:
		$FishingLine.points[0] = $RodTip.position
		$FishingLine.points[1] = $Bobber.position
		$FishingLine.points[1].y -= 8
		$HookLine.points[0] = $Bobber.position
		$HookLine.points[0].y += 16
		$HookLine.points[1] = $Hook.position
		$HookLine.points[1].y -= 4
		
func cast_line():
	$Bobber.position = $BobberStart.position
	$Bobber.position.x += casting_charge
	$Hook.position = $Bobber.position
	$Hook.rotation = 0
	$Hook.position.y += 100
	$HookLine.visible = true
	casting_charge = MIN_CAST_DISTANCE
	Input.stop_joy_vibration(device_id)
	
