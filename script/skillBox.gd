extends Control

var curr_level = 0

@onready var anim = $AnimationPlayer
@onready var texture = $TextureRect
@onready var lable = $TextureRect/Label

func new_skill(skill_name):
	# change skillBox to skill name to coding easier
	self.call_deferred('set_name', skill_name)
	# change textture to match with skill name
	match skill_name:
		'fire': texture.texture = load("res://asset/skills_2/pixil-frame-0.png")
		'rock': texture.texture = load("res://asset/skills_2/pixil-frame-1.png")
		'tank': texture.texture = load("res://asset/skills_2/pixil-frame-2.png")
		'heal': texture.texture = load("res://asset/skills_2/pixil-frame-3.png")
		'bomb': texture.texture = load("res://asset/skills_2/pixil-frame-4.png")
		'stop': texture.texture = load("res://asset/skills_2/pixil-frame-5.png")
	# up curr level to 1 and set lable to curr_level
	curr_level += 1
	lable.text = str(curr_level)
	# play animation update
	anim.call_deferred('play', 'update')
	pass

func update_skill():
	# up curr level to 1 and set lable to curr_level
	curr_level += 1
	lable.text = str(curr_level)
	# play animation update
	anim.call_deferred('play', 'update')
	pass
