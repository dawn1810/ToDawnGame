extends ENEMIES

signal deaded

const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
var face = 1

var enter_text: String
var rand_text: String

@onready var anim = $AnimationPlayer
@onready var control_anim = $CanvasLayer/Control/AnimationPlayer
@onready var key_board = $CanvasLayer/Control/TextEdit
@onready var key = $key
@onready var extra_sprites = $extraSprintes
@onready var dict = read_json_file("res://sample.json")

func _ready():
# random text for character:
	rand_text = generate_word(characters, face);
	key.get_child(0).text = rand_text
# set beuty full for text
	update_key_board("Type all letters > Enter to attack / Backspace to delete")

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.pressed:
			play_audio()
			if event.keycode == 4194308 && enter_text.length() > 0: # Backspace key
				enter_text = enter_text.erase(enter_text.length() - 1, 1)
				update_key_board(enter_text)
			elif event.keycode == 4194309: # Enter key
				if enter_text == rand_text:
					face += 1
					if face > 9:
						dead()
					else:
						rand_text = generate_word_2(face);
						# change letter for main sprite
						change_letter()
						key.get_child(0).text = rand_text[0]
						for i in range(1, rand_text.length()):
							extra_sprites.get_child(i-1).visible = true
							extra_sprites.get_child(i-1).change_letter()
							key.get_child(i).text = rand_text[i]
							
				enter_text = ""
				update_key_board(enter_text)
			elif event.keycode in range(65, 91): # is letter
				enter_text += OS.get_keycode_string(event.keycode)
				update_key_board(enter_text)

func dead():
	play_boss_explose()
	emit_signal("deaded")
	control_anim.call_deferred('play', 'disappear')
	anim.call_deferred('play', 'explose')
	speed = 0
	# yield for audio finish before queue free
	await audio.finished
	call_deferred("queue_free")
	
	# clear all enemies on stage
	var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
	if (len(enemies_appear) > 0):
		for enemy in enemies_appear:
			enemy.dead()

func parse_json(text):
	return JSON.parse_string(text)

func read_json_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary

func change_letter():
	anim.play("change_letter")
	await anim.animation_finished
	anim.play("idle")

func update_key_board(enter_text):
	key_board.text = " >> " +  enter_text

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

func generate_word_2(face):
	return dict[str(face)].pick_random()



