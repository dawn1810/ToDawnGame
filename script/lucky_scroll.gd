extends Control

@onready var btn1 = $VBoxContainer/HBoxContainer/TextureButton
@onready var btn2 = $VBoxContainer/HBoxContainer/TextureButton2
@onready var btn3 = $VBoxContainer/HBoxContainer/TextureButton3

var rand_list = range(6)

func _ready():
	_scrolling()

func _scrolling() :
	rand_list.shuffle()
	# set up buttons normal and hover
	# button 1:
	btn1.texture_normal = load('res://asset/skills_2/pixil-frame-' + str(rand_list[0]) +'.png')
	btn1.texture_hover = load('res://asset/skills/pixil-frame-' + str(rand_list[0]) +'.png')
	
	# button 2:
	btn2.texture_normal = load('res://asset/skills_2/pixil-frame-' + str(rand_list[1]) +'.png')
	btn2.texture_hover = load('res://asset/skills/pixil-frame-' + str(rand_list[1]) +'.png')
	
	# button 3:
	btn3.texture_normal = load('res://asset/skills_2/pixil-frame-' + str(rand_list[2]) +'.png')
	btn3.texture_hover = load('res://asset/skills/pixil-frame-' + str(rand_list[2]) +'.png')

func _update_skills(index):
	print(index)
	match(index):
		0: if Global.fire <= 3: Global.fire += 1
		1: if Global.rock <= 3: Global.rock += 1
		2: if Global.tank <= 3: Global.tank += 1
		3: if Global.heal <= 3: Global.heal += 1
		4: if Global.bomb <= 3: Global.bomb += 1
		5: if Global.stop <= 3: Global.stop += 1

func _on_texture_button_button_up():
	btn1.disabled = true
	btn2.disabled = true
	btn3.disabled = true
	_update_skills(rand_list[0])


func _on_texture_button_2_button_up():
	btn1.disabled = true
	btn2.disabled = true
	btn3.disabled = true	
	_update_skills(rand_list[1])


func _on_texture_button_3_button_up():
	btn1.disabled = true
	btn2.disabled = true
	btn3.disabled = true
	_update_skills(rand_list[2])
