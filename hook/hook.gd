extends Area2D

var hooked_fish

func _ready():
	pass


func _on_Hook_area_entered(area):
	if area.is_in_group("fish"):
		queue_free()
