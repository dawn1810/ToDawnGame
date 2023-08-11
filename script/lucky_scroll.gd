extends Control

@onready var btn1 = $VBoxContainer/HBoxContainer/TextureButton
@onready var btn2 = $VBoxContainer/HBoxContainer/TextureButton2
@onready var btn3 = $VBoxContainer/HBoxContainer/TextureButton3
@onready var skills_info = $skilInfo
@onready var anim = $AnimationPlayer

@onready var dict = read_json_file('res://skill.json')

var rand_list = range(6)

func _ready():
	_scrolling()
#	hide()

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
	
	# restart 
	anim.play("start")

func _update_skills(index):
	print(index)
	match(index):
		0: if Global.fire <= 3: Global.fire += 1
		1: if Global.rock <= 3: Global.rock += 1
		2: if Global.tank <= 3: Global.tank += 1
		3: if Global.heal <= 3: Global.heal += 1
		4: if Global.bomb <= 3: Global.bomb += 1
		5: if Global.stop <= 3: Global.stop += 1

func parse_json(text):
	return JSON.parse_string(text)

func read_json_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary

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


func _on_texture_button_mouse_entered():
	skills_info.text = dict[str(rand_list[0])]

func _on_texture_button_2_mouse_entered():
	skills_info.text = dict[str(rand_list[1])]

func _on_texture_button_3_mouse_entered():
	skills_info.text = dict[str(rand_list[2])]
