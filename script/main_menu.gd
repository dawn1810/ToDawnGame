extends Control

@onready var main_menu = $mainMenu
@onready var options = $options
@onready var video = $video
@onready var audio = $audio
@onready var credit = $credit

func _ready():
	# set all bus audio db to 10
	volume(0, 10)
	volume(1, 10)
	volume(2, 10)

func show_and_hide(show, hide):
	show.show()
	hide.hide()

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)

func _on_play_pressed():
	# delay for audio
	await get_tree().create_timer(0.1).timeout
	# change scene to main scene (start playing game)
	get_tree().change_scene_to_file('res://Scene/main.tscn')

func _on_quit_pressed():
	# delay for audio
	await get_tree().create_timer(0.1).timeout
	# quit game
	get_tree().quit()

func _on_options_pressed():
	# go to options
	show_and_hide(options, main_menu)

func _on_credit_pressed():
	# go to credit
	show_and_hide(credit, main_menu)

func _on_video_pressed():
	# go to video options:
	show_and_hide(video, options)

func _on_audio_pressed():
	# go to audio options:
	show_and_hide(audio, options)

func _on_back_pressed():
	# back to mainmenu:
	show_and_hide(main_menu, options)

func _on_fullscreen_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_window_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_vback_pressed():
	# back to options:
	show_and_hide(options, video)

func _on_aback_pressed():
	# back to options:
	show_and_hide(options, audio)

func _on_cback_pressed():
	# back to mainmenu:
	show_and_hide(main_menu, credit)

func _on_master_value_changed(value):
	if value == 0:
		AudioServer.set_bus_mute(0, true)
	else :
		AudioServer.set_bus_mute(0, false)
		volume(0, value)

func _on_music_value_changed(value):
	if value == 0:
		AudioServer.set_bus_mute(1, true)
	else :
		AudioServer.set_bus_mute(1, false)
		volume(1, value)

func _on_soundfx_value_changed(value):
	if value == 0:
		AudioServer.set_bus_mute(2, true)
	else :
		AudioServer.set_bus_mute(2, false)
		volume(2, value)
