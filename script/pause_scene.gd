extends Control

const main_menu = preload("res://Scene/main_menu.tscn")

@onready var setting = $setting
@onready var paused = $paused
@onready var video = $video
@onready var audio = $audio
@onready var master_slider = $audio/VBoxContainer/master/master
@onready var music_slider = $audio/VBoxContainer/music/music
@onready var soundfx_slider = $audio/VBoxContainer/soundFX/soundfx

func _ready():
	# set all bus audio db to Global value
	volume(0, Global.master)
	volume(1, Global.music)
	volume(2, Global.soundfx)

func _unhandled_input(event):
	if Input.is_action_just_pressed('pause') && !visible:
		# set play as default replay button
		defalt_focus($paused/HBoxContainer/continue)
		
		get_tree().paused = true
		show()
	elif Input.is_action_just_pressed('pause') && visible:
		get_tree().paused = false
		hide()

func defalt_focus(node):
	node.grab_focus()

func show_and_hide(show, hide):
	show.show()
	hide.hide()

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)

func _on_continue_pressed():
	get_tree().paused = false
	hide()

func _on_setting_pressed():
	# set play as default video button
	defalt_focus($setting/HBoxContainer/video)
	
	show_and_hide(setting, paused)

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu)

func _on_video_pressed():
	# set play as default fullscrene button
	defalt_focus($video/VBoxContainer/fullscreen)
	
	show_and_hide(video, setting)

func _on_audio_pressed():
	# set play as default master slider
	defalt_focus($audio/VBoxContainer/master/master)
	
	show_and_hide(audio, setting)

func _on_back_pressed():
	# set play as default replay button
	defalt_focus($paused/HBoxContainer/continue)
	show_and_hide(paused, setting)

func _on_aback_pressed():
	# set play as default video button
	defalt_focus($setting/HBoxContainer/video)
	
	show_and_hide(setting, audio)

func _on_vback_pressed():
	# set play as default video button
	defalt_focus($setting/HBoxContainer/video)
	
	show_and_hide(setting, video)

func _on_fullscreen_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_window_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

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
