extends ENEMIES

@export var power = 0

const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
const colors = ['idle', 'idle_2']

var rand_letter = generate_word(characters, 1)

@onready var label = $key/Label
@onready var anim = $AnimationPlayer

func _ready():
# make random colar for key:
	anim.play(colors.pick_random())
# random power of enemy from 2 to 5:
	power = randi_range(2, 5)
# random text for character:
	label.text = rand_letter + ' x ' + str(power)

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.is_released() && OS.get_keycode_string(event.keycode) == rand_letter:
			power -= 1
			label.text = rand_letter + ' x ' + str(power)
			if power <= 0:
				dead()

func dead():
	anim.call_deferred('play', 'disappear')
	speed = 0

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

