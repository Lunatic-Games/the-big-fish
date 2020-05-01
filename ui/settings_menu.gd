extends MarginContainer

signal go_back

const SLIDER_SPEED = 100
const SLIDER_JUMP = 5

var music_slider_held = false
var sfx_slider_held = false
var bus_layout = preload("res://audio_settings.tres")

func _ready():
	$VBoxContainer/FullscreenContainer/CheckBox.pressed = OS.window_fullscreen
	
	AudioServer.set_bus_layout(bus_layout)
	
	var music_level = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	var music_level_lin = db2linear(music_level)
	var music_slider = $VBoxContainer/MusicContainer/HSlider
	music_slider.value = music_slider.max_value * music_level_lin
	
	var sfx_level = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	var sfx_level_lin = db2linear(sfx_level)
	var sfx_slider = $VBoxContainer/SFXContainer/HSlider
	sfx_slider.value = sfx_slider.max_value * sfx_level_lin

# Handle slider scrolling and keypresses
func _process(delta):
	if !visible:
		return
	if music_slider_held:
		if Input.is_action_pressed("ui_right"):
			$VBoxContainer/MusicContainer/HSlider.value += SLIDER_SPEED * delta
			update_music()
		if Input.is_action_pressed("ui_left"):
			$VBoxContainer/MusicContainer/HSlider.value -= SLIDER_SPEED * delta
			update_music()
	if sfx_slider_held:
		if Input.is_action_pressed("ui_right"):
			$VBoxContainer/SFXContainer/HSlider.value += SLIDER_SPEED * delta 
		if Input.is_action_pressed("ui_left"):
			$VBoxContainer/SFXContainer/HSlider.value -= SLIDER_SPEED * delta
			
	if Input.is_action_just_pressed("ui_cancel"):
		$BackSFX.play()
		visible = false
		emit_signal("go_back")

# Return to previous menu
func _on_BackButton_pressed():
	$BackSFX.play()
	visible = false
	emit_signal("go_back")

func update_music():
	var value = ($VBoxContainer/MusicContainer/HSlider.value 
		/ $VBoxContainer/MusicContainer/HSlider.max_value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),
		linear2db(value))
	var _err = ResourceSaver.save("audio_settings.tres", AudioServer.generate_bus_layout())
		
func update_sfx():
	var value = ($VBoxContainer/SFXContainer/HSlider.value 
		/ $VBoxContainer/SFXContainer/HSlider.max_value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),
		linear2db(value))
	var _err = ResourceSaver.save("audio_settings.tres", AudioServer.generate_bus_layout())

# Toggle fullscreen
func _on_Fullscreen_pressed():
	$AcceptSFX.play()
	var check_box = get_node("VBoxContainer/FullscreenContainer/CheckBox")
	check_box.pressed = !check_box.pressed
	OS.window_fullscreen = !OS.window_fullscreen
	ProjectSettings.set_setting("display/window/size/fullscreen", OS.window_fullscreen)
	if !OS.window_fullscreen:
		OS.set_window_size(Vector2(1024, 576))
		OS.set_window_position(OS.get_screen_size() * 0.5 - OS.get_window_size() * 0.5)
	var _err = ProjectSettings.save_custom("res://settings.godot")

# Toggle screenshake
func _on_Screenshake_pressed():
	var check_box = get_node("VBoxContainer/ScreenshakeContainer/CheckBox")
	check_box.pressed = !check_box.pressed
	# Need to add screenshake

# Highlight label too
func _on_Music_HSlider_focus_entered():
	$VBoxContainer/MusicContainer/Label.pressed = true

# Remove label highlight and reset holding
func _on_Music_HSlider_focus_exited():
	$VBoxContainer/MusicContainer/Label.pressed = false
	$VBoxContainer/MusicContainer/HoldTimer.stop()
	music_slider_held = false

# Highlight label too
func _on_SFX_HSlider_focus_entered():
	$VBoxContainer/SFXContainer/Label.pressed = true

# Remove label highlight and reset holding
func _on_SFX_HSlider_focus_exited():
	$VBoxContainer/SFXContainer/Label.pressed = false
	$VBoxContainer/SFXContainer/HoldTimer.stop()
	sfx_slider_held = false

# Handle sliding for music bar
func _on_Music_HSlider_gui_input(_event):
	var timer = get_node("VBoxContainer/MusicContainer/HoldTimer")
	var slider = get_node("VBoxContainer/MusicContainer/HSlider")
	handle_slider_logic(timer, slider, "music_slider_held")
	update_music()

# Count as holding after timeout
func _on_Music_HoldTimer_timeout():
	music_slider_held = true

# Handle sliding for SFX bar
func _on_SFX_HSlider_gui_input(_event):
	var timer = get_node("VBoxContainer/SFXContainer/HoldTimer")
	var slider = get_node("VBoxContainer/SFXContainer/HSlider")
	handle_slider_logic(timer, slider, "sfx_slider_held")
	update_sfx()

# Count as holding after timeout
func _on_SFX_HoldTimer_timeout():
	sfx_slider_held = true
	
# Do single jumps or count as holding after set time
func handle_slider_logic(timer, slider, toggle_name):
	if Input.is_action_just_pressed("ui_right") and timer.is_stopped():
		timer.start()
		$AcceptSFX.play()
		slider.value += SLIDER_JUMP
	if Input.is_action_just_pressed("ui_left") and timer.is_stopped():
		timer.start()
		$AcceptSFX.play()
		slider.value -= SLIDER_JUMP
	if Input.is_action_just_released("ui_left") and !Input.is_action_pressed("ui_right"):
		timer.stop()
		set(toggle_name, false)
	if Input.is_action_just_released("ui_right") and !Input.is_action_pressed("ui_left"):
		timer.stop()
		set(toggle_name, false)
