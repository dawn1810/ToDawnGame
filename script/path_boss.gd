extends ENEMIES

signal deaded

const EXTRA_SPRITE = preload("res://Scene/extra_sprite.tscn")

const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

var matrix = [
	null, null, null, null, null,
	null, null, null, null, null,
	null, null, null, null, null,
	null, null, null, null, null,
	null, null, null, null, null,
]

# choose the first index
var start_index = randi_range(0, 24)
var curr_index = start_index

@onready var anim = $AnimationPlayer
@onready var keys = $key
@onready var pos_list = $posList
@onready var sprites = $extraSprites
@onready var sprite = $Sprite2D

func _ready():
# random text for character:
	var rand_text = generate_word(characters, 1)
	
	create_map(start_index)
	generate_dir_letter()

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		# left
		if event.pressed:
			if sprites.get_child_count() == 2:
				dead()
			
			if OS.get_keycode_string(event.keycode) == keys.get_child(1).text:
				if (curr_index  % 5) - 1 >= 0 && matrix[curr_index - 1] != null:
					_move(curr_index - 1)
				generate_dir_letter()
			elif OS.get_keycode_string(event.keycode) == keys.get_child(2).text:
				if (curr_index  % 5) + 1 < 5 && matrix[curr_index + 1] != null:
					_move(curr_index + 1)
				generate_dir_letter()
			elif OS.get_keycode_string(event.keycode) == keys.get_child(0).text:
				if curr_index - 5 >= 0 && matrix[curr_index - 5] != null:
					_move(curr_index - 5)
				generate_dir_letter()
			elif OS.get_keycode_string(event.keycode) == keys.get_child(3).text:
				if curr_index + 5 < 25 && matrix[curr_index + 5] != null:
					_move(curr_index + 5)
				generate_dir_letter()

func dead():
	emit_signal("deaded")
	anim.call_deferred('stop')
	anim.call_deferred('play', 'destroy')
	speed = 0
	
	# clear all enemies on stage
	var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
	if (len(enemies_appear) > 0):
		for enemy in enemies_appear:
			enemy.dead()

func spawn_path(index: int):
	# spawn extra sprite:
	var extra_sprite = EXTRA_SPRITE.instantiate()
	
	extra_sprite.position = pos_list.get_child(index).position
	
	sprites.add_child(extra_sprite)
	
	matrix[index] = extra_sprite

func rand_next_index(curr_index: int, dirs) -> int:
	if len(dirs) == 0:
		return -1
	var rand_dir = dirs.pick_random()
	dirs.erase(rand_dir)
	match rand_dir:
		# left
		0:
			# not out of range and not have sprite yet:
			if (curr_index  % 5) - 1 >= 0 && matrix[curr_index - 1] == null:
				return curr_index - 1
		# right
		1:
			# not out of range and not have sprite yet:
			if (curr_index  % 5) + 1 < 5 && matrix[curr_index + 1] == null:
				return curr_index + 1
		# top
		2:
			# not out of range and not have sprite yet:
			if curr_index - 5 >= 0 && matrix[curr_index - 5] == null:
				return curr_index - 5
		# bottom
		3:
			# not out of range and not have sprite yet:
			if curr_index + 5 < 25 && matrix[curr_index + 5] == null:
				return curr_index + 5
	return rand_next_index(curr_index, dirs)

func _move(update_index):
	# destroy current box
	matrix[curr_index].anim.play("explose")
	matrix[curr_index] = null
	# update posion of character
	curr_index = update_index
	sprite.position = pos_list.get_child(update_index).position
	keys.position = pos_list.get_child(update_index).position

func create_map(start_index):
	# set up start position
	sprite.position = pos_list.get_child(start_index).position
	keys.position = pos_list.get_child(start_index).position
	
	while start_index != -1:
		spawn_path(start_index)
		start_index = rand_next_index(start_index, range(4))

func generate_dir_letter():
	var chars = range(26)
	for i in keys.get_children():
		var rand_char = chars.pick_random() 
		i.text = characters[rand_char]
		chars.erase(rand_char)

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word



