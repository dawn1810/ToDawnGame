extends Control

const click_sound1 = preload("res://audio/click_audio/mixkit-camera-shutter-click-1133.wav")
const click_sound2 = preload("res://audio/click_audio/mixkit-stapling-paper-2995.wav")

@onready var anim = $AnimationPlayer
@onready var main_menu = preload("res://Scene/main_menu.tscn")
@onready var audio = $AudioStreamPlayer2D

func _on_replay_pressed():
	# random click sound:
	match randi_range(0, 1):
		0: audio.stream = click_sound1
		1: audio.stream = click_sound2
	audio.play()
	await audio.finished
	
	get_tree().reload_current_scene()

func _on_menu_pressed():
	# random click sound:
	match randi_range(0, 1):
		0: audio.stream = click_sound1
		1: audio.stream = click_sound2
	audio.play()
	await audio.finished
	
	get_tree().change_scene_to_packed(main_menu)


# replay button custom anim
func _on_replay_focus_entered():
	anim.play("replay_focus")

func _on_replay_focus_exited():
	anim.play("RESET")

func _on_replay_mouse_entered():
	anim.play("replay_focus")

func _on_replay_mouse_exited():
	anim.play("RESET")


func _on_menu_focus_exited():
	anim.play("menu_focus")

func _on_menu_focus_entered():
	anim.play("RESET")

func _on_menu_mouse_entered():
	anim.play("menu_focus")

func _on_menu_mouse_exited():
	anim.play("RESET")
	
