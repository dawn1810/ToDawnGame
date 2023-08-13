extends Control

@onready var btn1 = $VBoxContainer/HBoxContainer/TextureButton
@onready var btn2 = $VBoxContainer/HBoxContainer/TextureButton2
@onready var btn3 = $VBoxContainer/HBoxContainer/TextureButton3
@onready var skills_info = $skilInfo
@onready var anim = $AnimationPlayer

@onready var dict = read_json_file('res://skill.json')

var rand_list = range(6)
var next_slot = 1

func _ready():
#	_scrolling() # for testing only
	hide()

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
	match(index):
		0: 
			if Global.fire <= 3: 
				Global.fire += 1
				if (Global.fire == 1): # add new skill to next slot
					get_parent().get_parent().get_node('Ontop/HBoxContainer/skillsBar/slot' + str(next_slot)).new_skill('fire')
					next_slot += 1
				else: # update current skill
					get_parent().get_parent().get_node('Ontop/HBoxContainer/skillsBar/fire').update_skill()
		1: 
			if Global.rock <= 3: 
				Global.rock += 1
				if (Global.rock == 1): # add new skill to next slot
					get_parent().get_parent().get_node('Ontop/HBoxContainer/skillsBar/slot' + str(next_slot)).new_skill('rock')
					next_slot += 1
				else: # update current skill
					get_parent().get_parent().get_node('Ontop/HBoxContainer/skillsBar/rock').update_skill()
		2: 
			if Global.tank <= 3: 
				Global.tank += 1
				if (Global.tank == 1): # add new skill to next slot
					get_parent().get_parent().get_node('Ontop/HBoxContainer/skillsBar/slot' + str(next_slot)).new_skill('tank')
					next_slot += 1
				else: # update current skill
					get_parent().get_parent().get_node('Ontop/HBoxContainer/skillsBar/tank').update_skill()
		3: 
			if Global.heal <= 3: 
				Global.heal += 1
				if (Global.heal == 1): # add new skill to next slot
					get_parent().get_parent().get_node('Ontop/HBoxContainer/skillsBar/slot' + str(next_slot)).new_skill('heal')
					next_slot += 1
				else: # update current skill
					get_parent().get_parent().get_node('Ontop/HBoxContainer/skillsBar/heal').update_skill()
		4: 
			if Global.bomb <= 3: 
				Global.bomb += 1
				if (Global.bomb == 1): # add new skill to next slot
					get_parent().get_parent().get_node('Ontop/HBoxContainer/skillsBar/slot' + str(next_slot)).new_skill('bomb')
					next_slot += 1
				else: # update current skill
					get_parent().get_parent().get_node('Ontop/HBoxContainer/skillsBar/bomb').update_skill()
		5: 
			if Global.stop <= 3: 
				Global.stop += 1
				if (Global.stop == 1): # add new skill to next slot
					get_parent().get_parent().get_node('Ontop/HBoxContainer/skillsBar/slot' + str(next_slot)).new_skill('stop')
					next_slot += 1
				else: # update current skill
					get_parent().get_parent().get_node('Ontop/HBoxContainer/skillsBar/stop').update_skill()
	
	# hide lucky scroll
	anim.call_deferred('play', 'hide')
	await anim.animation_finished
	# yield animation finished then restart game
	get_parent().get_parent().restart_game_after_scroll()

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
