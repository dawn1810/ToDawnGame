extends Control

const background_music1 = preload("res://audio/background_audio.mp3")
const background_music2 = preload("res://audio/background_audio2.mp3")
const background_music3 = preload("res://audio/background_audio3.mp3")

@onready var main_menu = $mainMenu
@onready var options = $options
@onready var video = $video
@onready var audio = $audio
@onready var credit = $credit
@onready var music = $AudioStreamPlayer2D

func _ready():
	rand_background_music()
	# set play as default focus button
	defalt_focus($mainMenu/VBoxContainer/play)
	# set all bus audio db to Global value
	volume(0, Global.master)
	volume(1, Global.music)
	volume(2, Global.soundfx)

func defalt_focus(node):
	node.grab_focus()

func rand_background_music():
	match randi_range(0, 2):
		0: music.stream = background_music1
		1: music.stream = background_music2
		2: music.stream = background_music3
	
	music.play()

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
	# set focus for video button
	defalt_focus($options/VBoxContainer/video)
	# go to options
	show_and_hide(options, main_menu)

func _on_credit_pressed():
	# set play as default back button
	defalt_focus($credit/VBoxContainer/cback)
	# go to credit
	show_and_hide(credit, main_menu)

func _on_video_pressed():
	# set play as default fullscreen button
	defalt_focus($video/VBoxContainer/fullscreen)
	# go to video options:
	show_and_hide(video, options)

func _on_audio_pressed():
	# set play as default master slider
	get_node("audio/VBoxContainer/master/master").grab_focus()
	# go to audio options:
	show_and_hide(audio, options)

func _on_back_pressed():
	# set play as default focus button
	defalt_focus($mainMenu/VBoxContainer/play)
	# back to mainmenu:
	show_and_hide(main_menu, options)

func _on_fullscreen_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_window_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_vback_pressed():
	# set focus for video button
	defalt_focus($options/VBoxContainer/video)
	# back to options:
	show_and_hide(options, video)

func _on_aback_pressed():
	# set focus for video button
	defalt_focus($options/VBoxContainer/video)
	# back to options:
	show_and_hide(options, audio)

func _on_cback_pressed():
	# set play as default focus button
	defalt_focus($mainMenu/VBoxContainer/play)
	# back to mainmenu:
	show_and_hide(main_menu, credit)

func _on_master_value_changed(value):
	if value == 0:
		AudioServer.set_bus_mute(0, true)
	else :
		AudioServer.set_bus_mute(0, false)
		Global.master = value
		volume(0, value)

func _on_music_value_changed(value):
	if value == 0:
		AudioServer.set_bus_mute(1, true)
	else :
		AudioServer.set_bus_mute(1, false)
		Global.music = value
		volume(1, value)

func _on_soundfx_value_changed(value):
	if value == 0:
		AudioServer.set_bus_mute(2, true)
	else :
		AudioServer.set_bus_mute(2, false)
		Global.soundfx = value
		volume(2, value)

func _on_audio_stream_player_2d_finished():
	rand_background_music()
