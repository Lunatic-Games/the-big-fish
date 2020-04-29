extends Area2D

signal fish_hooked

export (bool) var in_water
var hooked_fish

func _physics_process(_delta):
	if is_instance_valid(hooked_fish):
		global_position = hooked_fish.get_mouth_position()
		global_position.y += 3
	else:
		hooked_fish = null


func _on_Hook_area_entered(area):
	if visible and area.is_in_group("fish"):
		emit_signal("fish_hooked", area)
		hooked_fish = area
		area.hooked()
		visible = false
		
func release():
	hooked_fish = null
