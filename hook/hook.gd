extends Area2D

var hooked_fish

func _physics_process(delta):
	if is_instance_valid(hooked_fish):
		global_position = hooked_fish.global_position


func _on_Hook_area_entered(area):
	if area.is_in_group("fish"):
		hooked_fish = area
		visible = false
