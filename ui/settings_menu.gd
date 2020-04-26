extends MarginContainer

signal go_back

const SLIDER_SPEED = 100
const SLIDER_JUMP = 5

var music_slider_held = false
var sfx_slider_held = false

func _process(delta):
	if music_slider_held:
		if Input.is_action_pressed("ui_right"):
			$VBoxContainer/MusicContainer/HSlider.value += SLIDER_SPEED * delta 
		if Input.is_action_pressed("ui_left"):
			$VBoxContainer/MusicContainer/HSlider.value -= SLIDER_SPEED * delta
	if sfx_slider_held:
		if Input.is_action_pressed("ui_right"):
			$VBoxContainer/SFXContainer/HSlider.value += SLIDER_SPEED * delta 
		if Input.is_action_pressed("ui_left"):
			$VBoxContainer/SFXContainer/HSlider.value -= SLIDER_SPEED * delta
			
	if visible and Input.is_action_just_pressed("ui_cancel"):
		visible = false
		emit_signal("go_back")


func _on_BackButton_pressed():
	visible = false
	emit_signal("go_back")


func _on_Fullscreen_pressed():
	var check_box = get_node("VBoxContainer/FullscreenContainer/CheckBox")
	check_box.pressed = !check_box.pressed
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Screenshake_pressed():
	var check_box = get_node("VBoxContainer/ScreenshakeContainer/CheckBox")
	check_box.pressed = !check_box.pressed
	# Need to add screenshake


func _on_Music_HSlider_focus_entered():
	$VBoxContainer/MusicContainer/Label.pressed = true

func _on_Music_HSlider_focus_exited():
	$VBoxContainer/MusicContainer/Label.pressed = false
	$VBoxContainer/MusicContainer/HoldTimer.stop()
	music_slider_held = false

func _on_SFX_HSlider_focus_entered():
	$VBoxContainer/SFXContainer/Label.pressed = true

func _on_SFX_HSlider_focus_exited():
	$VBoxContainer/SFXContainer/Label.pressed = false
	$VBoxContainer/SFXContainer/HoldTimer.stop()
	sfx_slider_held = false

func _on_Music_HSlider_gui_input(_event):
	var timer = get_node("VBoxContainer/MusicContainer/HoldTimer")
	var slider = get_node("VBoxContainer/MusicContainer/HSlider")
	handle_slider_logic(timer, slider, "music_slider_held")


func _on_Music_HoldTimer_timeout():
	music_slider_held = true


func _on_SFX_HSlider_gui_input(_event):
	var timer = get_node("VBoxContainer/SFXContainer/HoldTimer")
	var slider = get_node("VBoxContainer/SFXContainer/HSlider")
	handle_slider_logic(timer, slider, "sfx_slider_held")

func _on_SFX_HoldTimer_timeout():
	sfx_slider_held = true
	

func handle_slider_logic(timer, slider, toggle_name):
	if Input.is_action_just_pressed("ui_right") and timer.is_stopped():
		timer.start()
		slider.value += SLIDER_JUMP
	if Input.is_action_just_pressed("ui_left") and timer.is_stopped():
		timer.start()
		slider.value -= SLIDER_JUMP
	if Input.is_action_just_released("ui_left") and !Input.is_action_pressed("ui_right"):
		timer.stop()
		set(toggle_name, false)
	if Input.is_action_just_released("ui_right") and !Input.is_action_pressed("ui_left"):
		timer.stop()
		set(toggle_name, false)
