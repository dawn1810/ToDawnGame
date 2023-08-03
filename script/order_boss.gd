extends ENEMIES

signal deaded

const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

var freq = [.5, .3, .2, .2, .1, .1]
var answer_text: Array
var enter_text: String
var click = false

@onready var keys = $key
@onready var anim = $AnimationPlayer
@onready var sprites = $exrtaSprites
@onready var control_anim = $CanvasLayer/Control/AnimationPlayer
@onready var key_board = $CanvasLayer/Control/TextEdit

func _ready():
	for i in keys.get_children():
		i.text = generate_word(characters, 1)
		answer_text.append(i.text)
		answer_text.sort()

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == 4194308 && enter_text.length() > 0: # Backspace key
				# appear letter for easier order letters
				print(enter_text[-1])
				for i in range(keys.get_child_count()-1,0,-1): # loop from backwards
					if keys.get_child(i).text == enter_text[-1] && !keys.get_child(i).visible:
						keys.get_child(i).show()
						break

				enter_text = enter_text.erase(enter_text.length() - 1, 1)
				update_key_board(enter_text)
				
			elif event.keycode == 4194309: # Enter key
				if enter_text == str(answer_text):
					dead()
				else:
					update_key_board("")
			elif event.keycode in range(65, 91): # is letter
				enter_text += OS.get_keycode_string(event.keycode)
				update_key_board(enter_text)
				# hide letter for easier order letters
				print(OS.get_keycode_string(event.keycode))
				for i in keys.get_children():
					if i.text == OS.get_keycode_string(event.keycode) and i.visible:
						i.hide()
						break

func dead():
	emit_signal("deaded")
	
	anim.call_deferred('play', 'explose')
	speed = 0
	
	# clear all enemies on stage
	var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
	if (len(enemies_appear) > 0):
		for enemy in enemies_appear:
			enemy.dead()

func update_key_board(enter_text):
	key_board.text = " >> " +  enter_text

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word



