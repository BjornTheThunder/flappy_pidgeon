extends CanvasLayer

signal pause
signal toggle_random_background

var is_paused: bool = false

var bus_music_index: int
var bus_sfx_index: int

func _ready() -> void:
	bus_music_index = AudioServer.get_bus_index("Music")
	bus_sfx_index = AudioServer.get_bus_index("SFX")


func _on_pause_button_pressed() -> void:
	$Menu/SelectSound.play()
	
	pause.emit()
	is_paused = !is_paused
	if is_paused:
		play_activate_animation()
		get_tree().paused = true
	else:
		play_disable_animation()
		get_tree().paused = false


func _on_toggle_music_button_pressed() -> void:
	$Menu/SelectSound.play()
	
	if %ToggleMusicButton.button_pressed:
		AudioServer.set_bus_volume_db(bus_music_index, linear_to_db(0))
	else:
		AudioServer.set_bus_volume_db(bus_music_index, linear_to_db(1))

func _on_toggle_sound_button_pressed() -> void:
	$Menu/SelectSound.play()
	
	if %ToggleSoundButton.button_pressed:
		AudioServer.set_bus_volume_db(bus_sfx_index, linear_to_db(0))
	else:
		AudioServer.set_bus_volume_db(bus_sfx_index, linear_to_db(1))

func _on_toggle_random_background_button_pressed() -> void:
	$Menu/SelectSound.play()
	
	toggle_random_background.emit()
	pass # Replace with function body.

func play_activate_animation() -> void:
	$AnimationPlayer.play("activate")

func play_disable_animation() -> void:
	$AnimationPlayer.play("disable")


func _on_info_button_pressed() -> void:
	$Menu.hide()
	$InfoUI.show()
	$Menu/SelectSound.play()


func _on_ok_button_pressed() -> void:
	$Menu.show()
	$InfoUI.hide()
	$Menu/SelectSound.play()


func _on_git_hub_button_pressed() -> void:
	OS.shell_open("https://github.com/BjornTheThunder/flappy_pidgeon")

func _on_itch_button_pressed() -> void:
	OS.shell_open("https://ergane-studios.itch.io/")

func _on_google_play_button_pressed() -> void:
	pass # Replace with function body.
