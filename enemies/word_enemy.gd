extends ENEMIES

signal deaded

@export var extra_sprite = preload("res://Scene/extra_sprite.tscn")

const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

var freq = [.8, .0, .0, .0]
var curr_pos = Vector2.ZERO
var curr_letter = 0
var step = Vector2(65, 0)

@onready var anim = $AnimationPlayer
@onready var sprites = $extraSprites
@onready var keys = $key/HBoxContainer
@onready var main_sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var buff_col = $buffSpeeda/CollisionShape2D
@onready var tail_col = $tailCol
@onready var dict = read_json_file("res://sample.json")
@onready var rand_word: String = generate_word()

func _ready():
	# set up all letter in word
	for i in range(rand_word.length()):
		spawn_enemies(i, curr_pos)
		# update curr position
		curr_pos += step
	
	# set tail collision to the end of enemy
	tail_col.position.x += (rand_word.length() - 1) * 65
	
	# set position of sprite to 

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
	if event is InputEventKey && curr_letter < rand_word.length():
		if event.is_released() && OS.get_keycode_string(event.keycode) == rand_word[curr_letter]:
			# update collition shape fix enemy
			collision.position.x += 65
			buff_col.position.x += 65
			# hide just delete letter
			keys.get_child(curr_letter).text = ''
			sprites.get_child(curr_letter).anim.call_deferred('play', 'explose_2')
			curr_letter += 1
			if curr_letter == rand_word.length():
				# random gift:
				rand_gift()
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
	collision.set_deferred("disabled", true)
	buff_col.set_deferred("disabled", true)
	tail_col.set_deferred("disabled", true)
	speed = 0
	
	# remove all sprite left before dead
	for i in range(sprites.get_child_count()):
		keys.get_child(i).text = ''
		if sprites.get_child(i).visible:
			sprites.get_child(i).anim.call_deferred('play', 'explose_2')
		# only waiting at the final one
		if i == sprites.get_child_count() - 1:
			await sprites.get_child(i).anim.animation_finished
	
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

