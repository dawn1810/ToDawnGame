extends ENEMIES

signal deaded

@export var extra_sprite = preload("res://Scene/extra_sprite.tscn")

const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

var freq = [.8, .0, .0, .0]
var curr_pos = Vector2.ZERO
var curr_letter = 0
var step = Vector2(65, 0)

@onready var dict = read_json_file("res://sample.json")
@onready var anim = $AnimationPlayer
@onready var sprites = $extraSprites
@onready var keys = $key/HBoxContainer
@onready var rand_word: String = generate_word()
@onready var main_sprite = $Sprite2D

func _ready():
	# set up all letter in word
	for i in range(rand_word.length()):
		spawn_enemies(i, curr_pos)
		# update curr position
		curr_pos += step

func rand_enemies(freq) -> int:
	var total: float
	for i in freq:
		total += i
	
	for i in range(len(freq)):
		if randf_range(.0, total) >= total - freq[i]: 
			return i
			break
		if i == len(freq) - 1: return i;
		total -= freq[i]
	return -1

func spawn_enemies(index, pos):
	var instance = extra_sprite.instantiate()
	
	instance.position = pos
	sprites.add_child(instance)
	
	# set up key location
	set_up_new_key(index)

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.is_released() && OS.get_keycode_string(event.keycode) == rand_word[curr_letter]:
			keys.get_child(curr_letter).text = ''
			sprites.get_child(curr_letter).anim.call_deferred('play', 'explose_2')
			curr_letter += 1
			if curr_letter == rand_word.length():
				dead()

func set_up_new_key(index):
	keys.add_child(Label.new())
	keys.get_child(index).modulate = '000000'
	keys.get_child(index).horizontal_alignment = 1
	keys.get_child(index).vertical_alignment = 1
	keys.get_child(index).custom_minimum_size.x = 64
	keys.get_child(index).text = rand_word[index]

func dead():
	emit_signal("deaded")
	speed = 0
	call_deferred("queue_free")

func parse_json(text):
	return JSON.parse_string(text)

func read_json_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary

func generate_word():
	var rand_num = str(randi_range(2, 11))
	return dict[rand_num].pick_random()

