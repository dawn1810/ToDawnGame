extends ENEMIES

@export var power = 0

const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
const colors = ['idle', 'idle_2']

var rand_letter = generate_word(characters, 1)

@onready var label = $key/Label
@onready var anim = $AnimationPlayer

func _ready():
# make random colar for key:
	match colors.pick_random():
		'idle':
			label.modulate = '5c2a00'
			anim.play('idle')
		'idle_2':
			label.modulate = 'ffeddc'
			anim.play('idle_2')
# random power of enemy from 2 to 5:
	power = randi_range(2, 5)
# random text for character:
	rand_letter = generate_word(characters, 1);
	label.text = rand_letter + ' x ' + str(power)

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.is_released() && OS.get_keycode_string(event.keycode) == rand_letter:
			play_audio()
			power -= 1
			label.text = rand_letter + ' x ' + str(power)
			if power <= 0:
				rand_gift()
				dead()

func dead():
	play_audio()
	anim.call_deferred('play', 'explose')
	speed = 0

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

