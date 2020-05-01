extends VideoPlayer


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		_on_Splash_finished()


func _on_Splash_finished():
	var _err = get_tree().change_scene("res://ui/tutorial_menu.tscn")
