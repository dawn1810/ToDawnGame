extends Control

const main_menu = preload("res://Scene/main_menu.tscn")

func game_over_focus():
	# set play as default replay button
	$VBoxContainer/HBoxContainer/replay.grab_focus()

func _on_replay_pressed():
	# delay for audio
	await get_tree().create_timer(0.1).timeout
	# reload scene
	get_tree().reload_current_scene()

func _on_menu_pressed():
	# delay for audio
	await get_tree().create_timer(0.1).timeout
	#go to main menu
	get_tree().change_scene_to_packed(main_menu)
