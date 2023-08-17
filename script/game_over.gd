extends Control

@onready var anim = $AnimationPlayer
@onready var main_menu = preload("res://Scene/main_menu.tscn")

func _on_replay_pressed():
	get_tree().reload_current_scene()

func _on_menu_pressed():
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
	
