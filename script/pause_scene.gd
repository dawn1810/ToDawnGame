extends Control

signal continue_game

const click_sound1 = preload("res://audio/click_audio/mixkit-camera-shutter-click-1133.wav")
const click_sound2 = preload("res://audio/click_audio/mixkit-stapling-paper-2995.wav")
const main_menu = preload("res://Scene/main_menu.tscn")

@onready var anim = $AnimationPlayer
@onready var audio = $AudioStreamPlayer2D

func _ready():
	# set play as default replay button
	get_node("VBoxContainer/HBoxContainer/continue").grab_focus()

func _click_audio_play():
	# random click sound:
	match randi_range(0, 1):
		0: audio.stream = click_sound1
		1: audio.stream = click_sound2
	audio.play()
	await audio.finished

func show_and_hide(show, hide):
	show.show()
	hide.hide()

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)

func _on_continue_pressed():
	_click_audio_play()
	emit_signal('continue_game')

func _on_setting_pressed():
	_click_audio_play()

func _on_menu_pressed():
	_click_audio_play()
	get_tree().change_scene_to_packed(main_menu)




