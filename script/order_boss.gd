extends ENEMIES

signal deaded

const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

var freq = [.5, .3, .2, .2, .1, .1]
var answer_text: Array
var enter_text: String
var hide_keys: Array
var click = false

@onready var keys = $key
@onready var anim = $AnimationPlayer
@onready var control_anim = $CanvasLayer/Control/AnimationPlayer
@onready var key_board = $CanvasLayer/Control/TextEdit

func _ready():
	for i in keys.get_children():
		i.text = generate_word(characters, 1)
		answer_text.append(i.text)
		answer_text.sort()
		
	update_key_board("Type all letters that sort by alphabet")

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == 4194308 && enter_text.length() > 0: # Backspace key
				# appear letter for easier order letters
				keys.get_child(hide_keys.pop_back()).show()
				# remove last letter:
				enter_text = enter_text.erase(enter_text.length() - 1, 1)
				update_key_board(enter_text)
				
			elif event.keycode == 4194309: # Enter key
				if enter_text == array_to_string(answer_text):
					dead()
				else:
					# show all keys
					for i in keys.get_children():
						i.show()
					# clear enter text
					enter_text = ""
					update_key_board("")
			elif event.keycode in range(65, 91): # is letter
				enter_text += OS.get_keycode_string(event.keycode)
				update_key_board(enter_text)
				# hide letter for easier order letters
				for i in range(keys.get_child_count()):
					if keys.get_child(i).text == OS.get_keycode_string(event.keycode) && keys.get_child(i).visible:
						keys.get_child(i).hide()
						# save i in hide keys
						hide_keys.append(i)
						break
					
					# if no key like it or wisible append -1 to avoid null hide_keys
					if i == keys.get_child_count() - 1:
						hide_keys.append(-1)

func dead():
	emit_signal("deaded")
	
	anim.call_deferred('play', 'explose')
	speed = 0
	
	# clear all enemies on stage
	var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
	if (len(enemies_appear) > 0):
		for enemy in enemies_appear:
			enemy.dead()

func array_to_string(arr: Array) -> String:
	var s = ""
	for i in arr:
		s += String(i)
	return s

func update_key_board(enter_text):
	key_board.text = " >> " +  enter_text

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word



