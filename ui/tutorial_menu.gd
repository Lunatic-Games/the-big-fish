extends ColorRect


func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and $AnimationPlayer.current_animation != "fade_in":
		$AnimationPlayer.play("fade_out")

func faded_out():
	var _err = get_tree().change_scene("res://core/core.tscn")
