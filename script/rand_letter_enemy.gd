extends ENEMIES


const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
const colors = ['idle', 'idle_2']

var curr_letter = 0

@onready var label = $key/Label
@onready var anim = $AnimationPlayer
@onready var dict = read_json_file("res://sample.json")
@onready var rand_letter = generate_word()
@onready var power = rand_letter.length()

func _ready():
# make random color for key:
	match colors.pick_random():
		'idle':
			label.modulate = '5c2a00'
			anim.play('idle')
		'idle_2':
			label.modulate = 'ffeddc'
			anim.play('idle_2')
# random text for character:
	label.text = rand_letter[curr_letter]

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.is_released() && OS.get_keycode_string(event.keycode) == label.text:
			play_audio()
			power -= 1
			if power <= 0:
				rand_gift()
				dead()
			else :
				anim.play("change_letter")
				# change to next letter (change color randomly)
				curr_letter += 1
				label.text = rand_letter[curr_letter]
				await anim.animation_finished
				match colors.pick_random():
					'idle':
						label.modulate = '5c2a00'
						anim.play('idle')
					'idle_2':
						label.modulate = 'ffeddc'
						anim.play('idle_2')

func dead():
	play_audio()
	anim.call_deferred('play', 'explose')
	speed = 0

func parse_json(text):
	return JSON.parse_string(text)

func read_json_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary

func generate_word():
	var rand_num = str(randi_range(2, 5))
	return dict[rand_num].pick_random()

